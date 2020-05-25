#!/bin/bash

set -e
# Output colours
COL='\033[1;34m'
NOC='\033[0m'
if [[ ! -n "$1" ]]; then
      echo -e  "$COL> Call ./up.sh with cluster size, for example: ./up.sh small$NOC"
  exit 1
fi
#------------------------------------------------------------------------------#
NUM_WORKER_NODES=$(cat ${1}.tfvars | grep instance_count | awk '{print $NF}')
STACK_NAME=$(cat ${1}.tfvars | grep cluster_name | awk '{print $NF}' | sed 's/"//g')
WORKER_NODES_INSTANCE_TYPE=$(cat ${1}.tfvars | grep instance_type | awk '{print $NF}' | sed 's/"//g')
REGION=$(cat ${1}.tfvars | grep region | awk '{print $NF}' | sed 's/"//g')
#------------------------------------------------------------------------------#

echo -e  "$COL> Ensuring SSH key pair for worker node connectivity$NOC"
KEY_PAIR_EXISTS=$(aws ec2  describe-key-pairs --query "KeyPairs[*].KeyName" --output text | grep edge-key-pair | wc -l)
if [ $KEY_PAIR_EXISTS -eq 0 ]; then
  aws ec2 create-key-pair --key-name edge-key-pair
fi
echo -e  "$COL> Deploying CloudFormation stack (may take up to 15 minutes)...$NOC"
aws cloudformation deploy \
  --template-file eks.yml \
  --region "$REGION" \
  --capabilities CAPABILITY_IAM \
  --stack-name "$STACK_NAME" \
  --parameter-overrides \
      KeyPairName="edge-key-pair" \
      NumWorkerNodes="$NUM_WORKER_NODES" \
      WorkerNodesInstanceType="$WORKER_NODES_INSTANCE_TYPE"

echo -e "\n$COL> Updating kubeconfig file...$NOC"
aws eks update-kubeconfig --name "$STACK_NAME"

echo -e "\n$COL> Configuring worker nodes (to join the cluster)...$NOC"
# Get worker nodes role ARN from CloudFormation stack output
arn=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='WorkerNodesRoleArn'].OutputValue" \
  --output text)
# Enable worker nodes to join the cluster:
# https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html#eks-create-cluster
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: $arn
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF

echo -e "\n$COL> Almost done! Cluster will be ready when all nodes have a 'Ready' status."
echo -e "> Check it with: kubectl get nodes --watch$NOC"

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
INTERNAL_DOMAIN_NAME=$(cat ${1}.tfvars | grep internal_domain_name | awk '{print $NF}' | sed 's/"//g')
EXTERNAL_DOMAIN_NAME=$(cat ${1}.tfvars | grep external_domain_name | awk '{print $NF}' | sed 's/"//g')
#------------------------------------------------------------------------------#

echo -e  "$COL> Ensuring SSH key pair for worker node connectivity$NOC"
KEY_PAIR_EXISTS=$(aws ec2  describe-key-pairs --region "$REGION" --query "KeyPairs[*].KeyName" --output text | grep edge-key-pair | wc -l)
if [ $KEY_PAIR_EXISTS -eq 0 ]; then
  aws ec2 create-key-pair --region "$REGION" --key-name edge-key-pair
fi
echo -e  "$COL> Deploying CloudFormation stack (may take up to 15 minutes)...$NOC"
set +e
aws cloudformation deploy \
  --template-file eks.yml \
  --region "$REGION" \
  --capabilities CAPABILITY_IAM \
  --stack-name "$STACK_NAME" \
  --parameter-overrides \
      KeyPairName="edge-key-pair" \
      NumWorkerNodes="$NUM_WORKER_NODES" \
      WorkerNodesInstanceType="$WORKER_NODES_INSTANCE_TYPE" \
      InternalDomain="$INTERNAL_DOMAIN_NAME" \
      ExternalDomain="$EXTERNAL_DOMAIN_NAME"

DEPLOY_RESULT=$?
set -e

if [ $DEPLOY_RESULT -eq 0 ]; then
  echo -e "$COL> Wait for EKS to become ready (5 minutes)$NOC"
  sleep 300
elif [ $DEPLOY_RESULT -ne 255 ]; then
  echo -e "$COL> CloudFormation stack deployment is failed$NOC"
  exit 1
fi
echo -e "\n$COL> Updating kubeconfig file...$NOC"
aws eks update-kubeconfig --region "$REGION" --name "$STACK_NAME"

echo -e "\n$COL> Configuring worker nodes (to join the cluster)...$NOC"

arn=$(aws cloudformation describe-stacks \
  --region "$REGION" \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[?OutputKey=='WorkerNodesRoleArn'].OutputValue" \
  --output text)

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

if [ $INTERNAL_DOMAIN_NAME != "NOT_SET" ] || [ $EXTERNAL_DOMAIN_NAME != "NOT_SET" ]; then
  echo -e "\n$COL> certs = "
  cert=$(aws cloudformation describe-stacks \
    --region "$REGION" \
    --stack-name "$STACK_NAME" \
    --query "Stacks[0].Outputs[?OutputKey=='InternalCert'].OutputValue" \
    --output text)
  echo -n $cert" "
  aws acm describe-certificate --certificate-arn $cert --query 'Certificate.DomainValidationOptions[*].ResourceRecord.[Name,Value]' --output text
  cert=$(aws cloudformation describe-stacks \
    --region "$REGION" \
    --stack-name "$STACK_NAME" \
    --query "Stacks[0].Outputs[?OutputKey=='ExternalCert'].OutputValue" \
    --output text)
  echo -n $cert" "
  aws acm describe-certificate --certificate-arn $cert --query 'Certificate.DomainValidationOptions[*].ResourceRecord.[Name,Value]' --output text
  echo -e "$NOC"
fi
echo -e "\n$COL> connect = aws eks update-kubeconfig --region "$REGION" --name $STACK_NAME $NOC"
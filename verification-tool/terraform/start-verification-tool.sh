#!/bin/bash
COL='\033[1;34m'
NOC='\033[0m'

# General variables
INSTANCE_TYPE=m5.4xlarge
AMI_ID=ami-08f3d892de259504d
VOLUME_SIZE=1024
echo -e  "$COL> Checking for existing SSH key$NOC"
KEY_PAIR_EXISTS=$(aws ec2  describe-key-pairs --query "KeyPairs[*].KeyName" --output text | grep edge-key-pair | wc -l)
if [ $KEY_PAIR_EXISTS -ne 0 ]; then
  echo -e  "$COL> Removing SSH key$NOC"
  aws ec2 delete-key-pair --key-name edge-key-pair
  sleep 5
fi
echo -e  "$COL> Creating SSH key pair for verification server$NOC"
rm -rf edge-key-pair.pem
aws ec2 create-key-pair --key-name edge-key-pair --query "KeyMaterial" --output text > edge-key-pair.pem
chmod 400 edge-key-pair.pem
sleep 60
echo -e "$COL> Creating verification server$NOC"
echo $(aws ec2 run-instances  --instance-type $INSTANCE_TYPE \
   --key-name edge-key-pair \
   --image-id $AMI_ID \
   --block-device-mappings '[{"DeviceName":"/dev/sdg","Ebs":{"VolumeSize":'${VOLUME_SIZE}',"DeleteOnTermination":true}}]' \
   --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=verification-tool}]' 'ResourceType=volume,Tags=[{Key=Name,Value=verification-tool}]' \
   --user-data file://init-verification-tool.sh --query "Instances[*].InstanceId" --output text) > instance_id
echo -e "$COL> Verification server created. to connect it please use the following command:\n${NOC}"
echo "ssh -i \"edge-key-pair.pem\" ec2-user@"$(aws ec2 describe-instances --instance-ids $(cat instance_id) --query "Reservations[*].Instances[*].PublicDnsName" --output text)

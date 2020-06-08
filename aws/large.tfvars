instance_count = 3
instance_type  = "c5n.4xlarge"
cluster_name   = "edge-cluster"
region         = "us-east-1"
# ----------------------------------
# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# map_roles = [{ rolearn = "arn:aws:iam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
# ----------------------------------
# For cloudwatch logs in edge uncomment the following line
# additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
# ----------------------------------
# To configure ACM creation, uncomment the following variables and set with correct values
# internal_domain_name = "NOT_SET"
# external_domain_name = "NOT_SET"
# ----------------------------------
# To configure pre-existing VPC, configure the following variables
# edge_eks_subnets = ["subnet-123123", "subnet-456456", "subnet-789789"]
# edge_asg_subnet = ["subnet-123123"]
instance_count = 3
instance_type  = "c5n.2xlarge"
cluster_name   = "edge1-cluster"
region         = "us-east-1"
# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# map_roles = [{ rolearn = "arn:awskkkiam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
# For cloudwatch logs in edge uncomment the following line
additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
# To configure ACM creation, uncomment the following variables and set with correct values
# internal_domain_name = "NOT_SET"
# external_domain_name = "NOT_SET"
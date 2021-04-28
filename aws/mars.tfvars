cluster_name   = "edge-cluster"
region         = "us-east-1"
components_instance_count = 9
components_instance_type = "c5.4xlarge"
cache_instance_type = "r5.8xlarge"
db_instance_type = "r5.2xlarge"
# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# map_roles = [{ rolearn = "arn:aws:iam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
# map_users = [{ userarn = "arn:aws:iam::012345678901:user/username", username = "admin", groups = ["system:masters"] }]
# For cloudwatch logs in edge uncomment the following line
# additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
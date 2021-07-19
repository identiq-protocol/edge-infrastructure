eks_cluster_name   = "twenty"
region         = "us-east-1"
eks_dynamic_instance_count = 1
eks_dynamic_instance_type = "c5.2xlarge"
eks_db_instance_count = 1
eks_cache_instance_type = "r5.large"
ec_instance_type = "cache.r5.large"
external_store = true
store_name = "twenty"
rds_engine = "postgres"
rds_engine_version = "12.5"
rds_parameter_group = "postgres12"
rds_storage_encrypted = false
# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# eks_map_roles = [{ rolearn = "arn:aws:iam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
# eks_map_users = [{ userarn = "arn:aws:iam::012345678901:user/username", username = "admin", groups = ["system:masters"] }]
# For cloudwatch logs in edge uncomment the following line
# eks_additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]

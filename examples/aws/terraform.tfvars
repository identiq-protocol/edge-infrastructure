eks_cluster_name = "edge-cluster"
region           = "us-east-1"

# Elasticache Redis
external_redis      = true         # Create an external redis using elasticache
external_redis_name = "edge-redis" # Name of the elasticache instance

### Uncomment the following lines to enable elasticache cluster mode
#ec_cluster_mode_creation_fix_enabled = true
#ec_cluster_mode_enabled              = true
#ec_cluster_mode_num_node_groups      = 2


cluster_autoscaler_enabled = true # Install cluster autoscaler

# RDS Postgres
external_db      = true      # Create an external postgres using RDS
external_db_name = "edge-db" # Name of the RDS instance

# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# eks_map_roles = [{ rolearn = "arn:aws:iam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
# eks_map_users = [{ userarn = "arn:aws:iam::012345678901:user/username", username = "admin", groups = ["system:masters"] }]
# For cloudwatch logs in edge uncomment the following line
# eks_additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]

### Uncomment to configure vpc endpoint service for us-east-1
# vpc_endpoint_service_name = com.amazonaws.vpce.us-east-1.vpce-svc-0964eccd96e1f130c
### Uncomment to configure vpc endpoint service for eu-central-1
# vpc_endpoint_service_name = com.amazonaws.vpce.eu-central-1.vpce-svc-0ead3a40b72d7e586

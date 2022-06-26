eks_cluster_name                        = "test"
region                                  = "us-east-1"
eks_dynamic_instance_count              = 1
eks_dynamic_instance_type               = "c5.2xlarge"
eks_cache_instance_type                 = "r5.large"
ec_instance_type                        = "cache.r6g.large"
external_redis                          = true
ec_cluster_mode_enabled                 = true
ec_cluster_mode_creation_fix_enabled    = true
ec_cluster_mode_num_node_groups         = 3
ec_cluster_mode_replicas_per_node_group = 0
ec_automatic_failover_enabled           = true
external_redis_name                     = "test"
ec_snapshot_retention_limit             = 0
#external_redis                  = false
#external_db                     = true
#rds_apply_immediately           = false
#rds_allow_major_version_upgrade = false
# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# eks_map_roles = [{ rolearn = "arn:aws:iam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
eks_map_users = [{ userarn = "arn:aws:iam::189347618452:user/aviel@identiq.com", username = "admin", groups = ["system:masters"] }]
# For cloudwatch logs in edge uncomment the following line
# eks_additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]

eks_cluster_name           = "edge-amex"
region                     = "us-east-1"
eks_dynamic_instance_count = 3
eks_base_instance_count    = 1
eks_dynamic_instance_type  = "c5.2xlarge"
eks_cache_instance_type    = "r5.xlarge"
ec_instance_type           = "cache.r6g.xlarge"
external_redis                  = true
external_db                     = true
external_redis_name             = "edge-amex"
rds_engine_version              = "13.7"
ec_subnet_single_az             = true
rds_multi_az                    = false
rds_instance_class              = "db.m6g.large"
rds_storage_type                = "gp3"

ec_transit_encryption_enabled = true
ec_snapshot_name = ""
#rds_apply_immediately           = false
#rds_allow_major_version_upgrade = false
# For configuring additional IAM roles to administer the cluster
# uncomment the variable below and set the correct IAM roles ARN.
# eks_map_roles = [{ rolearn = "arn:aws:iam::012345678901:role/edge-admin", username = "admin", groups = ["system:masters"] }]
# eks_map_users = [{ userarn = "arn:aws:iam::012345678901:user/username", username = "admin", groups = ["system:masters"] }]
# For cloudwatch logs in edge uncomment the following line
# eks_additional_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]

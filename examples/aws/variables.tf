variable "external_vpc" {
  description = "Sepcifies whether we want to use an externally created VPC"
  type        = bool
  default     = false
}

variable "eks_vpc_id" {
  description = "Specifies VPC ID in case of external VPC"
  type        = string
  default     = ""
}

variable "pinky_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    type        = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "eks_cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "eks_cluster_create_endpoint_private_access_sg_rule" {
  description = "Whether to create security group rules for the access to the Amazon EKS private API server endpoint. When is `true`, `cluster_endpoint_private_access_cidrs` must be setted."
  type        = bool
  default     = false
}

variable "eks_cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "eks_cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_private_subnets" {
  description = "Specifies private subnet IDs in case of external VPC"
  type        = list(string)
  default     = []
}

variable "eks_public_subnets" {
  description = "Specifies public subnet IDs in case of external VPC"
  type        = list(string)
  default     = []
}

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "identiq-vpc"
}

variable "vpc_cidrsubnet" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "vpc_enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the Default VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the Default VPC"
  type        = bool
  default     = true
}

variable "vpc_map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`"
  type        = bool
  default     = true
}

variable "vpc_endpoint_service_name" {
  description = <<EOT
    Endpoint service name to configure with Identiq endpoint service.
    Identiq endpoint service by region:
    us-east-1 : com.amazonaws.vpce.us-east-1.vpce-svc-0964eccd96e1f130c
    eu-central-1 : com.amazonaws.vpce.eu-central-1.vpce-svc-0ead3a40b72d7e586
  EOT
  type        = string
  default     = ""
}

variable "vpc_endpoint_type" {
  description = "Endpoint service type to create, default unless otherwise is Interface"
  type        = string
  default     = "Interface"
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
  default     = "edge"
}

variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "eks_map_roles" {
  description = "EKS additional IAM roles to add to the aws-auth configmap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "eks_map_users" {
  description = "EKS additional IAM users to add to the aws-auth configmap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "eks_additional_policies" {
  description = "EKS additional policies to be added to workers"
  type        = list(string)
  default     = []
}

variable "eks_wait_for_cluster_timeout" {
  description = "A timeout (in seconds) to wait for EKS cluster to be available"
  type        = number
  default     = 300
}

variable "eks_cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}`"
  type        = any
  default     = {}
  #  default = {
  #    resources = ["secrets"]
  #  }
}

variable "eks_cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = []
}
variable "eks_cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 7 days"
  type        = number
  default     = 7
}

### node groups variables ###

# master node group
variable "eks_master_create" {
  description = "Create EKS master node group"
  type        = bool
  default     = false
}

variable "eks_master_instance_types" {
  description = "EKS master worker group instance type"
  type        = list(string)
  default     = ["t3.small", "t3a.small"]
}

variable "eks_master_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_master_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
  default     = "BOTTLEROCKET_x86_64"
}

variable "eks_master_platform" {
  description = "Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported"
  type        = string
  default     = "bottlerocket"
}

variable "eks_master_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = 100
}

variable "eks_master_desired_count" {
  description = "EKS master node group instance desired count"
  type        = number
  default     = 2
}

variable "eks_master_min_size" {
  description = "EKS master worker group minimimum number of instances"
  type        = number
  default     = 0
}

variable "eks_master_max_size" {
  description = "EKS master node group max number of instances"
  type        = number
  default     = 4
}

# base node group
variable "eks_base_instance_types" {
  description = "EKS base worker group instance type"
  type        = list(string)
  default     = ["c6a.2xlarge", "c6i.2xlarge"]
}

variable "eks_base_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_base_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
  default     = "BOTTLEROCKET_x86_64"
}

variable "eks_base_platform" {
  description = "Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported"
  type        = string
  default     = "bottlerocket"
}

variable "eks_base_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = 100
}

variable "eks_base_desired_count" {
  description = "EKS master node group instance desired count"
  type        = number
  default     = 1
}

variable "eks_base_min_size" {
  description = "EKS master worker group minimimum number of instances"
  type        = number
  default     = 0
}

variable "eks_base_max_size" {
  description = "EKS master node group max number of instances"
  type        = number
  default     = 1
}

# dynamic node group
variable "eks_dynamic_instance_types" {
  description = "EKS dynamic worker group instance type"
  type        = list(string)
  default     = ["c6a.2xlarge", "c6i.2xlarge"]
}

variable "eks_dynamic_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_dynamic_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
  default     = "AL2_x86_64"
}

variable "eks_dynamic_platform" {
  description = "Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported"
  type        = string
  default     = "linux"
}

variable "eks_dynamic_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = 100
}

variable "eks_dynamic_desired_count" {
  description = "EKS dynamic node group instance desired count"
  type        = number
  default     = 2
}

variable "eks_dynamic_min_size" {
  description = "EKS dynamic worker group minimum number of instances"
  type        = number
  default     = 0
}

variable "eks_dynamic_max_size" {
  description = "EKS dynamic node group max number of instances"
  type        = number
  default     = 20
}

# cache node group
variable "eks_cache_instance_types" {
  description = "EKS cache worker group instance type"
  type        = list(string)
  default     = ["r6a.2xlarge", "r6i.2xlarge"]
}

variable "eks_cache_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_cache_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
  default     = "BOTTLEROCKET_x86_64"
}

variable "eks_cache_platform" {
  description = "Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported"
  type        = string
  default     = "bottlerocket"
}

variable "eks_cache_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = 100
}

variable "eks_cache_desired_count" {
  description = "EKS master node group instance desired count"
  type        = number
  default     = 1
}

variable "eks_cache_min_size" {
  description = "EKS master worker group minimum number of instances"
  type        = number
  default     = 0
}

variable "eks_cache_max_size" {
  description = "EKS master node group max number of instances"
  type        = number
  default     = 1
}

# db node group
variable "eks_db_instance_types" {
  description = "EKS db worker group instance type"
  type        = list(string)
  default     = ["m6a.xlarge", "m6i.xlarge"]
}

variable "eks_db_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_db_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
  default     = "BOTTLEROCKET_x86_64"
}

variable "eks_db_platform" {
  description = "Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported"
  type        = string
  default     = "bottlerocket"
}

variable "eks_db_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = 100
}

variable "eks_db_desired_count" {
  description = "EKS db node group instance desired count"
  type        = number
  default     = 1
}

variable "eks_db_min_size" {
  description = "EKS db worker group minimum number of instances"
  type        = number
  default     = 0
}

variable "eks_db_max_size" {
  description = "EKS db node group max number of instances"
  type        = number
  default     = 1
}
variable "eks_worker_ami_name_filter" {
  description = "Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster_version' is used."
  type        = string
  default     = ""
}
variable "eks_worker_ami_owner_id" {
  description = "The ID of the owner for the AMI to use for the AWS EKS workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft')."
  type        = string
  default     = "amazon"
}

variable "external_redis" {
  description = "Redis will be installed outside of EKS cluster (Elasticache)"
  type        = bool
  default     = false
}

variable "external_redis_name" {
  description = "External redis name (if enabled)"
  type        = string
  default     = "edge"
}

variable "ec_vpc_id" {
  description = "VPC ID in case we external VPC is provided"
  type        = string
  default     = ""
}
variable "ec_private_subnets" {
  description = "Private subnets for elasticache in case external VPC is provided"
  type        = list(string)
  default     = []
}
variable "ec_instance_type" {
  description = "Elastic cache instance type"
  type        = string
  default     = "cache.r7g.xlarge"
}

variable "ec_cluster_mode_enabled" {
  description = "Elastic cache flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  type        = bool
  default     = false
}
variable "ec_cluster_mode_creation_fix_enabled" {
  description = "Elastic cache flag to enable/disable the fix that pass avilability_zones [] and allow to create new EC cluster"
  type        = bool
  default     = false
}

variable "ec_cluster_mode_num_node_groups" {
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  type        = number
  default     = 0
}

variable "ec_cluster_mode_replicas_per_node_group" {
  description = "Elastic cache number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  type        = number
  default     = 0
}

variable "ec_cluster_size" {
  description = "Elastic cache number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
  type        = number
  default     = 1
}

variable "ec_apply_immediately" {
  description = "Elastic cache apply changes immediately"
  type        = bool
  default     = true
}

variable "ec_automatic_failover_enabled" {
  description = "Elastic cache automatic failover (Not available for T1/T2 instances)"
  type        = bool
  default     = false
}

variable "ec_engine_version" {
  description = "Elastic cache Redis engine version"
  type        = string
  default     = "7.0"
}

variable "ec_family" {
  description = "Elastic cache Redis family"
  type        = string
  default     = "redis7"
}

variable "ec_at_rest_encryption_enabled" {
  description = "Elastic cache enable encryption at rest"
  type        = bool
  default     = true
}

variable "ec_parameter" {
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "reserved-memory-percent"
      value = "10"
    }

  ]
}

variable "ec_snapshot_name" {
  description = "The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
  type        = string
  default     = null
}

variable "ec_snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 3
}

variable "ec_snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  type        = string
  default     = "06:30-07:30"
}

variable "ec_transit_encryption_enabled" {
  description = "Whether to enable Elastic cache encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis"
  type        = bool
  default     = false
}
variable "ec_subnet_single_az" {
  description = "Whether to Elastic cache subnet group with single subnet"
  type        = bool
  default     = true
}

variable "external_db" {
  description = "Database will be installed outside of EKS cluster (RDS)"
  type        = bool
  default     = true
}

variable "external_db_name" {
  description = "External db name (if enabled)"
  type        = string
  default     = "edge"
}

variable "rds_vpc_id" {
  description = "VPC ID in case we external VPC is provided"
  type        = string
  default     = ""
}

variable "rds_private_subnets" {
  description = "Private subnets for RDS in case external VPC is provided"
  type        = list(string)
  default     = []
}
variable "rds_sg_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "rds_sg_ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "rds_sg_ingress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "rds_sg_ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "rds_sg_ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "rds_sg_ingress_with_ipv6_cidr_blocks" {
  description = "List of ingress rules to create where 'ipv6_cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "rds_sg_ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  type        = list(map(string))
  default     = []
}

variable "rds_sg_ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type        = list(map(string))
  default     = []
}

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "13.15"
}

variable "rds_parameter_group_family" {
  description = "The engine version to use"
  type        = string
  default     = "postgres13"
}

variable "rds_db_name" {
  description = "The DB name to create"
  type        = string
  default     = "edge"
}

variable "rds_create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "rds_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "edge"
}

variable "rds_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:00:00-Sun:03:00"
}

variable "rds_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "03:00-06:00"
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "rds_snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05"
  type        = string
  default     = null
}

variable "rds_deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = false
}

variable "rds_performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = true
}

variable "rds_performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
  default     = 7
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = 1000
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.r7g.large"
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 14
}

variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
  type        = number
  default     = 60
}

variable "rds_max_allocated_storage" {
  description = "Max allocated storage"
  type        = number
  default     = 0
}

variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = null
}

variable "rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not."
  type        = string
  default     = "gp3"
}

variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = "true"
}

variable "rds_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default = [{
    apply_method = "pending-reboot",
    name         = "maintenance_work_mem"
    value        = "4194304"
    },
    {
      apply_method = "pending-reboot",
      name         = "checkpoint_timeout"
      value        = "1800"
    },
    {
      apply_method = "pending-reboot",
      name         = "max_wal_size"
      value        = "4096"
    },
    {
      apply_method = "pending-reboot",
      name         = "synchronous_commit"
      value        = "off"
    },
    {
      apply_method = "pending-reboot",
      name         = "wal_buffers"
      value        = "8192"
    },
    {
      apply_method = "pending-reboot",
      name         = "enable_hashagg"
      value        = "1"
    },
    {
      apply_method = "pending-reboot",
      name         = "hash_mem_multiplier"
      value        = "2.0"
  }]
}

variable "rds_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}
variable "rds_manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = false
}

variable "rds_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}
variable "default_tags" {
  description = "Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}

variable "tags" {
  description = "Any tags the user wishes to add to all resources of the edge"
  type        = map(string)
  default     = {}
}

variable "vpc_specific_subnet_newbits" {
  default     = 4
  type        = number
  description = "Specifies the edge subnet newbits for calculating the CIDR block"
}

variable "ec_appautoscaling_predefined_metric_type" {
  type        = string
  description = "The metric type."
  default     = "ElastiCacheDatabaseMemoryUsageCountedForEvictPercentage"
}

variable "ec_log_delivery_configuration" {
  type        = list(map(any))
  default     = []
  description = "The log_delivery_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks."
}

variable "ec_appautoscaling_target_value" {
  type        = number
  description = "The target value for the metric."
  default     = 80
}

variable "ec_appautoscaling_policy_type" {
  type        = string
  description = "The policy type. Valid values are StepScaling and TargetTrackingScaling. Defaults to StepScaling. Certain services only support only one policy type."
  default     = "TargetTrackingScaling"
}

variable "ec_appautoscaling_target_min_capacity" {
  type        = number
  description = "The min capacity of the scalable target."
  default     = 3
}

variable "ec_appautoscaling_target_max_capacity" {
  type        = number
  description = "The max capacity of the scalable target."
  default     = 100
}

variable "ec_appautoscaling_scalable_dimension" {
  type        = string
  description = "The scalable dimension of the scalable target."
  default     = "elasticache:replication-group:NodeGroups"
}

variable "ec_appautoscaling_service_namespace" {
  type        = string
  description = "The AWS service namespace of the scalable target."
  default     = "elasticache"
}

variable "ec_appautoscaling_scale_in_cooldown" {
  type        = number
  description = "The amount of time, in seconds, after a scale in activity completes before another scale in activity can start."
  default     = 300
}

variable "ec_appautoscaling_scale_out_cooldown" {
  type        = number
  description = "The amount of time, in seconds, after a scale out activity completes before another scale out activity can start."
  default     = 300
}

variable "ec_enable_app_autoscaling" {
  default     = true
  type        = bool
  description = "Enable app autoscaling for elasticache"
}

variable "ec_allow_all_egress" {
  type        = bool
  default     = true
  description = <<-EOT
    If `true`, the created security group for Elasticache will allow egress on all ports and protocols to all IP address.
    If this is false and no egress rules are otherwise specified, then no egress will be allowed.
    Defaults to `true` unless the deprecated `egress_cidr_blocks` is provided and is not `["0.0.0.0/0"]`, in which case defaults to `false`.
    EOT
}

variable "ec_data_tiering_enabled" {
  type        = bool
  default     = false
  description = "Enables Elasticache data tiering. Data tiering is only supported for replication groups using the r6gd node type."
}

### cluster autoscaler variables ###
variable "cluster_autoscaler_enabled" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = false
}

variable "cluster_autoscaler_verbosity_level" {
  description = "Verbosity level"
  type        = string
  default     = "0"
}

variable "cluster_autoscaler_namespace" {
  description = "Namespace to deploy cluster autoscaler"
  type        = string
  default     = "default"
}

variable "cluster_autoscaler_helm_chart_version" {
  description = "Cluster autoscaler helm chart version"
  type        = string
  default     = "9.36.0"
}

variable "cluster_autoscaler_image_tag" {
  description = "Cluster autoscaler image tag"
  type        = string
  default     = "v1.28.2"
}

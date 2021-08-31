data "aws_availability_zones" "available" {
  state = "available"
}

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  default     = "identiq-vpc"
}

variable "vpc_cidrsubnet" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "vpc_enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  default     = false
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the Default VPC"
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the Default VPC"
  default     = true
}

variable "vpc_endpoint_service_name" {
  description = "Endpoint service name to configure with Identiq endpoint service"
  default     = ""
}

variable "vpc_endpoint_type" {
  description = "Endpoint service type to create, default unless otherwise is Interface"
  default     = "Interface"
}

variable "region" {
  description = "region"
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
}

variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  default     = "1.19"
}

variable "eks_map_roles" {
  description = "EKS additional IAM roles to add to the aws-auth configmap"
  default     = []
}

variable "eks_map_users" {
  description = "EKS additional IAM users to add to the aws-auth configmap"
  default     = []
}

variable "eks_additional_policies" {
  description = "EKS additional policies to be added to workers"
  default     = []
}

variable "eks_wait_for_cluster_timeout" {
  description = "A timeout (in seconds) to wait for EKS cluster to be available"
  type        = number
  default     = 300
}

variable "eks_db_instance_type" {
  description = "EKS database worker group instance type"
  type        = string
  default     = "m5.large"
}

variable "eks_db_instance_count" {
  description = "EKS database worker group instance count which sets on_demand_base_capacity, asg_min_size, asg_desired_capacity"
  type        = number
  default     = 1
}

variable "eks_db_asg_min_size" {
  description = "EKS database worker group minimimum number of instances (asg_min_size)"
  type        = number
  default     = 0
}

variable "eks_cache_instance_type" {
  description = "EKS cache worker group instance type"
  type        = string
  default     = "r5.2xlarge"
}

variable "eks_cache_instance_count" {
  description = "EKS cache worker group instance count which sets on_demand_base_capacity, asg_min_size, asg_desired_capacity"
  type        = number
  default     = 1
}

variable "eks_cache_asg_min_size" {
  description = "EKS cache worker group minimimum number of instances (asg_min_size)"
  type        = number
  default     = 0
}

variable "eks_dynamic_instance_type" {
  description = "EKS dynamic worker group instance type"
  type        = string
  default     = "c5.2xlarge"
}

variable "eks_dynamic_instance_count" {
  description = "EKS dynamic worker group instance count which sets on_demand_base_capacity, asg_min_size, asg_desired_capacity"
  type        = number
  default     = 4
}
variable "eks_dynamic_asg_autoscaling" {
  description = "EKS dynamic worker group enable autoscaling"
  type        = bool
  default     = true
}

variable "eks_dynamic_asg_min_size" {
  description = "EKS dynamic worker group minimimum number of instances (asg_min_size)"
  type        = number
  default     = 0
}

variable "eks_base_instance_type" {
  description = "EKS base worker group instance type"
  type        = string
  default     = "c5.2xlarge"
}

variable "eks_base_instance_count" {
  description = "EKS base worker group instance count which sets on_demand_base_capacity, asg_min_size, asg_desired_capacity"
  type        = number
  default     = 1
}

variable "eks_base_asg_min_size" {
  description = "EKS base worker group minimimum number of instances (asg_min_size)"
  type        = number
  default     = 0
}

variable "eks_cluster_enabled_log_types" {
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}

variable "external_redis" {
  description = "Redis will be installed outside of EKS cluster (Elasticache)"
  type        = bool
  default     = false
}

variable "external_redis_name" {
  description = "External redis name (if enabled)"
  default     = "edge"
}

variable "ec_instance_type" {
  description = "Elastic cache instance type"
  type        = string
  default     = "cache.r5.2xlarge"
}

variable "ec_cluster_mode_enabled" {
  description = "Elastic cache flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
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
  default     = "6.x"
}

variable "ec_family" {
  description = "Elastic cache Redis family"
  type        = string
  default     = "redis6.x"
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
  default     = null
}

variable "ec_snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 3
}

variable "ec_snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "06:30-07:30"
}

variable "ec_transit_encryption_enabled" {
  description = "Whether to enable Elastic cache encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis"
  type        = bool
  default     = false
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

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "13.3"
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
  default     = "true"
}

variable "rds_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "edge"
}

variable "rds_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
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
  default     = "db.m5.large"
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

variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = null
}

variable "rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not."
  type        = string
  default     = "gp2"
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

variable "default_tags" {
  description = "Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable"
  default = {
    Terraform = "true"
  }
}

variable "tags" {
  description = "Any tags the user wishes to add to all resources of the edge"
  type        = map(string)
}

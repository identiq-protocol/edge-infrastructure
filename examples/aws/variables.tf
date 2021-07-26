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
  description = "Additional IAM roles to add to the aws-auth configmap"
  default     = []
}

variable "eks_map_users" {
  description = "Additional IAM users to add to the aws-auth configmap"
  default     = []
}

variable "eks_additional_policies" {
  description = "Additional policies to be added to workers"
  default     = []
}

variable "eks_wait_for_cluster_timeout" {
  description = "A timeout (in seconds) to wait for cluster to be available"
  default     = 300
}

variable "eks_db_instance_type" { default = "m5.large" }
variable "eks_db_instance_count" { default = 1 }
variable "eks_db_asg_min_size" { default = 0 }

variable "eks_cache_instance_type" { default = "r5.2xlarge" }
variable "eks_cache_instance_count" { default = 1 }
variable "eks_cache_asg_min_size" { default = 0 }

variable "eks_dynamic_instance_type" { default = "c5.4xlarge" }
variable "eks_dynamic_instance_count" { default = 4 }
variable "eks_dynamic_asg_min_size" { default = 0 }

variable "eks_base_instance_type" { default = "c5.2xlarge" }
variable "eks_base_instance_count" { default = 1 }
variable "eks_base_asg_min_size" { default = 0 }

variable "external_redis" {
  description = "Redis will be installed outside of EKS cluster (Elasticache)"
  type        = bool
  default     = false
}

variable "external_redis_name" {
  description = "External redis name (if enabled)"
  default     = "edge"
}
variable "ec_instance_type" { default = "cache.r5.2xlarge" }
variable "ec_cluster_mode_enabled" { default = false }
variable "ec_cluster_mode_replicas_per_node_group" { default = 0 }
variable "ec_cluster_size" { default = 1 }
variable "ec_apply_immediately" { default = true }
variable "ec_automatic_failover_enabled" { default = false }
variable "ec_engine_version" { default = "6.x" }
variable "ec_family" { default = "redis6.x" }
variable "ec_at_rest_encryption_enabled" { default = true }
variable "ec_transit_encryption_enabled" { default = false }

variable "external_db" {
  description = "Database will be installed outside of EKS cluster (RDS)"
  type        = bool
  default     = false
}

variable "external_db_name" {
  description = "External db name (if enabled)"
  default     = "edge"
}
variable "rds_engine" { default = "postgres" }
variable "rds_engine_version" { default = "13.3" }
variable "rds_parameter_group_family" { default = "postgres13" }
variable "rds_db_name" { default = "edge" }
variable "rds_create_monitoring_role" { default = "true" }
variable "rds_username" { default = "edge" }
variable "rds_multi_az" { default = true }
variable "rds_maintenance_window" { default = "Sun:00:00-Sun:03:00" }
variable "rds_backup_window" { default = "03:00-06:00" }
variable "rds_skip_final_snapshot" { default = true }
variable "rds_deletion_protection" { default = false }
variable "rds_performance_insights_enabled" { default = true }
variable "rds_performance_insights_retention_period" { default = 7 }
variable "rds_allocated_storage" { default = 1000 }
variable "rds_storage_encrypted" { default = true }
variable "rds_instance_class" { default = "db.m5.large" }
variable "rds_backup_retention_period" { default = 14 }
variable "rds_monitoring_interval" { default = 60 }
variable "rds_iops" { default = 3000 }
variable "rds_apply_immediately" { default = false }
variable "rds_parameters" { default = [] }
variable "rds_allow_major_version_upgrade" { default = false }

variable "tags" {
  default = {
    Owner       = "Identiq"
    Application = "IdentiqEdge"
  }
}

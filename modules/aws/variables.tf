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

variable "region" {
  description = "region"
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
}

variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  default     = "1.18"
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
  default     = "c5.4xlarge"
}

variable "eks_dynamic_instance_count" {
  description = "EKS dynamic worker group instance count which sets on_demand_base_capacity, asg_min_size, asg_desired_capacity"
  type        = number
  default     = 4
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

variable "external_store" {
  description = "MySQL and Redis data stores will be installed outside of EKS cluster (RDS and Elasticache)"
  type        = bool
  default     = false
}

variable "store_name" {
  description = "External store name (if enabled)"
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

variable "ec_transit_encryption_enabled" {
  description = "Whether to enable Elastic cache encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis"
  type        = bool
  default     = false
}

variable "rds_engine" { default = "mariadb" }
variable "rds_engine_version" { default = "10.3"}
variable "rds_parameter_group" { default = "mariadb10.3"}
variable "rds_db_name" { default = "edge" }
variable "rds_create_monitoring_role" { default = "true" }
variable "rds_username" { default = "edge" }
variable "rds_multi_az" { default = true }
variable "rds_maintenance_window" { default = "Sun:00:00-Sun:03:00"}
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

variable "tags" {
  default = {
    Owner       = "Identiq"
    Application = "IdentiqEdge"
  }
}

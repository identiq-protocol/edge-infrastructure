data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "cidrsubnet" {
  default = "10.0.0.0/16"
}

variable "instance_count" {
  default = "3"
}
variable "instance_type" {
  default = "c5n.4xlarge"
}

variable "cluster_name" {
  default = "edge-cluster"
}

variable "map_roles" {
  default = []
}

variable "map_users" {
  default = []
}

variable "additional_policies" {
  default = []
}

variable "db_instance_count" {default = 1}

variable "cache_instance_type" {default = "r5.2xlarge"}
variable "cache_instance_count" {default = 1}

variable "dynamic_instance_type" {default = "c5.4xlarge"}
variable "dynamic_instance_count" {default = 4}
variable "db_instance_type" {default = "m5.large"}
variable "base_instance_type" {default = "c5.2xlarge"}
variable "base_instance_count" {default = 1}


variable "external_store" { default = false }
variable "store_name" { default = "edge" }

variable "tags" {
  default = {
    Owner = "Identiq"
    Application = "IdentiqEdge"
  }
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

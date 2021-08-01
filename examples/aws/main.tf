provider "aws" {
  region = var.region
}

#terraform {
#  backend "s3" {
#    region   = "us-east-1"
#    role_arn = "arn:aws:iam::123456789:role/allow-rw-s3"
#    bucket   = "terraform-state"
#    key      = "production/aws/edge"
#    encrypt  = "true"
#  }
#}

module "edge-aws" {
  source = "../../../modules/aws"
  # vpc
  vpc_name                 = var.vpc_name
  vpc_cidrsubnet           = var.vpc_cidrsubnet
  vpc_enable_nat_gateway   = var.vpc_enable_nat_gateway
  vpc_enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  vpc_enable_dns_hostnames = var.vpc_enable_dns_hostnames
  vpc_enable_dns_support   = var.vpc_enable_dns_support
  region                   = var.region

  # eks
  eks_cluster_name             = var.eks_cluster_name
  eks_cluster_version          = var.eks_cluster_version
  eks_map_roles                = var.eks_map_roles
  eks_map_users                = var.eks_map_users
  eks_additional_policies      = var.eks_additional_policies
  eks_wait_for_cluster_timeout = var.eks_wait_for_cluster_timeout
  eks_db_instance_type         = var.eks_db_instance_type
  eks_db_instance_count        = var.eks_db_instance_count
  eks_db_asg_min_size          = var.eks_db_asg_min_size
  eks_cache_instance_type      = var.eks_cache_instance_type
  eks_cache_instance_count     = var.eks_cache_instance_count
  eks_cache_asg_min_size       = var.eks_cache_asg_min_size
  eks_dynamic_instance_count   = var.eks_dynamic_instance_count
  eks_dynamic_instance_type    = var.eks_dynamic_instance_type
  eks_dynamic_asg_min_size     = var.eks_dynamic_asg_min_size
  eks_base_instance_type       = var.eks_base_instance_type
  eks_base_instance_count      = var.eks_base_instance_count
  eks_base_asg_min_size        = var.eks_base_asg_min_size

  # rds
  external_db                               = var.external_db
  external_db_name                          = var.external_db_name
  rds_engine                                = var.rds_engine
  rds_engine_version                        = var.rds_engine_version
  rds_parameter_group_family                = var.rds_parameter_group_family
  rds_db_name                               = var.rds_db_name
  rds_create_monitoring_role                = var.rds_create_monitoring_role
  rds_username                              = var.rds_username
  rds_multi_az                              = var.rds_multi_az
  rds_maintenance_window                    = var.rds_maintenance_window
  rds_backup_window                         = var.rds_backup_window
  rds_skip_final_snapshot                   = var.rds_skip_final_snapshot
  rds_deletion_protection                   = var.rds_deletion_protection
  rds_performance_insights_enabled          = var.rds_performance_insights_enabled
  rds_performance_insights_retention_period = var.rds_performance_insights_retention_period
  rds_allocated_storage                     = var.rds_allocated_storage
  rds_storage_encrypted                     = var.rds_storage_encrypted
  rds_instance_class                        = var.rds_instance_class
  rds_backup_retention_period               = var.rds_backup_retention_period
  rds_monitoring_interval                   = var.rds_monitoring_interval
  rds_iops                                  = var.rds_iops
  rds_apply_immediately                     = var.rds_apply_immediately
  rds_parameters                            = var.rds_parameters
  rds_allow_major_version_upgrade           = var.rds_allow_major_version_upgrade

  # Elastic cache
  external_redis                          = var.external_redis
  external_redis_name                     = var.external_redis_name
  ec_instance_type                        = var.ec_instance_type
  ec_cluster_mode_enabled                 = var.ec_cluster_mode_enabled
  ec_cluster_mode_num_node_groups         = var.ec_cluster_mode_num_node_groups
  ec_cluster_mode_replicas_per_node_group = var.ec_cluster_mode_replicas_per_node_group
  ec_cluster_size                         = var.ec_cluster_size
  ec_apply_immediately                    = var.ec_apply_immediately
  ec_automatic_failover_enabled           = var.ec_automatic_failover_enabled
  ec_engine_version                       = var.ec_engine_version
  ec_family                               = var.ec_family
  ec_at_rest_encryption_enabled           = var.ec_at_rest_encryption_enabled
  ec_transit_encryption_enabled           = var.ec_transit_encryption_enabled
  ec_parameter                            = var.ec_parameter
  # General
  tags = var.tags
}

output "connect" {
  value = module.edge-aws.connect
}

output "nat_ips" {
  value = module.edge-aws.nat_ips
}

output "vpc_id" {
  value = module.edge-aws.vpc_id
}
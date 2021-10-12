provider "aws" {
  region = var.region
}

#terraform {
#  backend "s3" {
#    region   = "us-east-1"
#    bucket   = "terraform-state"
#    key      = "production/aws/edge"
#    encrypt  = "true"
#  }
#}

module "edge-aws" {
  source = "git@github.com:identiq-protocol/edge-infrastructure.git//modules/aws/?ref=0.0.17"

  # vpc
  external_vpc             = var.external_vpc
  vpc_name                 = var.vpc_name
  vpc_cidrsubnet           = var.vpc_cidrsubnet
  vpc_enable_nat_gateway   = var.vpc_enable_nat_gateway
  vpc_enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  vpc_enable_dns_hostnames = var.vpc_enable_dns_hostnames
  vpc_enable_dns_support   = var.vpc_enable_dns_support
  region                   = var.region

  # vpc endpoint
  vpc_endpoint_type         = var.vpc_endpoint_type
  vpc_endpoint_service_name = var.vpc_endpoint_service_name

  # eks
  eks_vpc_id                    = var.eks_vpc_id
  eks_private_subnets           = var.eks_private_subnets
  eks_public_subnets            = var.eks_public_subnets
  eks_cluster_name              = var.eks_cluster_name
  eks_cluster_version           = var.eks_cluster_version
  eks_map_roles                 = var.eks_map_roles
  eks_map_users                 = var.eks_map_users
  eks_additional_policies       = var.eks_additional_policies
  eks_wait_for_cluster_timeout  = var.eks_wait_for_cluster_timeout
  eks_db_instance_type          = var.eks_db_instance_type
  eks_db_instance_count         = var.eks_db_instance_count
  eks_db_asg_min_size           = var.eks_db_asg_min_size
  eks_db_root_encrypted         = var.eks_db_root_encrypted
  eks_cache_instance_type       = var.eks_cache_instance_type
  eks_cache_instance_count      = var.eks_cache_instance_count
  eks_cache_asg_min_size        = var.eks_cache_asg_min_size
  eks_cache_root_encrypted      = var.eks_cache_root_encrypted
  eks_dynamic_instance_count    = var.eks_dynamic_instance_count
  eks_dynamic_instance_type     = var.eks_dynamic_instance_type
  eks_dynamic_asg_min_size      = var.eks_dynamic_asg_min_size
  eks_dynamic_root_encrypted    = var.eks_dynamic_root_encrypted
  eks_base_instance_type        = var.eks_base_instance_type
  eks_base_instance_count       = var.eks_base_instance_count
  eks_base_asg_min_size         = var.eks_base_asg_min_size
  eks_base_root_encrypted       = var.eks_base_root_encrypted
  eks_cluster_enabled_log_types = var.eks_cluster_enabled_log_types
  eks_worker_ami_name_filter    = var.eks_worker_ami_name_filter
  eks_worker_ami_owner_id       = var.eks_worker_ami_owner_id

  # rds
  external_db                                  = var.external_db
  external_db_name                             = var.external_db_name
  rds_vpc_id                                   = var.rds_vpc_id
  rds_private_subnets                          = var.rds_private_subnets
  rds_sg_ingress_cidr_blocks                   = var.rds_sg_ingress_cidr_blocks
  rds_sg_ingress_ipv6_cidr_blocks              = var.rds_sg_ingress_ipv6_cidr_blocks
  rds_sg_ingress_prefix_list_ids               = var.rds_sg_ingress_prefix_list_ids
  rds_sg_ingress_rules                         = var.rds_sg_ingress_rules
  rds_sg_ingress_with_cidr_blocks              = var.rds_sg_ingress_with_cidr_blocks
  rds_sg_ingress_with_ipv6_cidr_blocks         = var.rds_sg_ingress_with_ipv6_cidr_blocks
  rds_sg_ingress_with_self                     = var.rds_sg_ingress_with_self
  rds_sg_ingress_with_source_security_group_id = var.rds_sg_ingress_with_source_security_group_id
  rds_engine                                   = var.rds_engine
  rds_engine_version                           = var.rds_engine_version
  rds_parameter_group_family                   = var.rds_parameter_group_family
  rds_db_name                                  = var.rds_db_name
  rds_create_monitoring_role                   = var.rds_create_monitoring_role
  rds_username                                 = var.rds_username
  rds_multi_az                                 = var.rds_multi_az
  rds_maintenance_window                       = var.rds_maintenance_window
  rds_backup_window                            = var.rds_backup_window
  rds_skip_final_snapshot                      = var.rds_skip_final_snapshot
  rds_deletion_protection                      = var.rds_deletion_protection
  rds_performance_insights_enabled             = var.rds_performance_insights_enabled
  rds_performance_insights_retention_period    = var.rds_performance_insights_retention_period
  rds_allocated_storage                        = var.rds_allocated_storage
  rds_storage_encrypted                        = var.rds_storage_encrypted
  rds_instance_class                           = var.rds_instance_class
  rds_backup_retention_period                  = var.rds_backup_retention_period
  rds_monitoring_interval                      = var.rds_monitoring_interval
  rds_storage_type                             = var.rds_storage_type
  rds_iops                                     = var.rds_iops
  rds_apply_immediately                        = var.rds_apply_immediately
  rds_parameters                               = var.rds_parameters
  rds_allow_major_version_upgrade              = var.rds_allow_major_version_upgrade

  # Elastic cache
  external_redis                          = var.external_redis
  external_redis_name                     = var.external_redis_name
  ec_vpc_id                               = var.ec_vpc_id
  ec_private_subnets                      = var.ec_private_subnets
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
  ec_snapshot_name                        = var.ec_snapshot_name
  ec_snapshot_retention_limit             = var.ec_snapshot_retention_limit
  ec_snapshot_window                      = var.ec_snapshot_window

  # General
  default_tags = var.default_tags
  tags         = var.tags
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

output "endpoint_address" {
  value = var.vpc_endpoint_service_name != "" ? module.edge-aws.endpoint_address : ""
}

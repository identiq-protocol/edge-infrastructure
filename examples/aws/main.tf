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
  source = "../../modules/aws"

  external_vpc                                       = var.external_vpc
  eks_vpc_id                                         = var.eks_vpc_id
  eks_cluster_endpoint_private_access                = var.eks_cluster_endpoint_private_access
  eks_cluster_create_endpoint_private_access_sg_rule = var.eks_cluster_create_endpoint_private_access_sg_rule
  eks_cluster_endpoint_public_access                 = var.eks_cluster_endpoint_public_access
  eks_cluster_endpoint_public_access_cidrs           = var.eks_cluster_endpoint_public_access_cidrs
  eks_private_subnets                                = var.eks_private_subnets
  eks_public_subnets                                 = var.eks_public_subnets
  vpc_name                                           = var.vpc_name
  vpc_cidrsubnet                                     = var.vpc_cidrsubnet
  vpc_enable_nat_gateway                             = var.vpc_enable_nat_gateway
  vpc_enable_vpn_gateway                             = var.vpc_enable_vpn_gateway
  vpc_enable_dns_hostnames                           = var.vpc_enable_dns_hostnames
  vpc_enable_dns_support                             = var.vpc_enable_dns_support
  vpc_map_public_ip_on_launch                        = var.vpc_map_public_ip_on_launch
  vpc_endpoint_service_name                          = var.vpc_endpoint_service_name
  vpc_endpoint_type                                  = var.vpc_endpoint_type
  region                                             = var.region
  eks_cluster_name                                   = var.eks_cluster_name
  eks_cluster_version                                = var.eks_cluster_version
  eks_map_roles                                      = var.eks_map_roles
  eks_map_users                                      = var.eks_map_users
  eks_additional_policies                            = var.eks_additional_policies
  eks_wait_for_cluster_timeout                       = var.eks_wait_for_cluster_timeout
  eks_cluster_encryption_config                      = var.eks_cluster_encryption_config

  # Node Groups Variables
  eks_master_create         = var.eks_master_create
  eks_master_instance_types = var.eks_master_instance_types
  eks_master_capacity_type  = var.eks_master_capacity_type
  eks_master_ami_type       = var.eks_master_ami_type
  eks_master_platform       = var.eks_master_platform
  eks_master_desired_count  = var.eks_master_desired_count
  eks_master_min_size       = var.eks_master_min_size
  eks_master_max_size       = var.eks_master_max_size

  eks_base_instance_types = var.eks_base_instance_types
  eks_base_capacity_type  = var.eks_base_capacity_type
  eks_base_ami_type       = var.eks_base_ami_type
  eks_base_platform       = var.eks_base_platform
  eks_base_desired_count  = var.eks_base_desired_count
  eks_base_min_size       = var.eks_base_min_size
  eks_base_max_size       = var.eks_base_max_size

  eks_dynamic_instance_types = var.eks_dynamic_instance_types
  eks_dynamic_capacity_type  = var.eks_dynamic_capacity_type
  eks_dynamic_ami_type       = var.eks_dynamic_ami_type
  eks_dynamic_platform       = var.eks_dynamic_platform
  eks_dynamic_desired_count  = var.eks_dynamic_desired_count
  eks_dynamic_min_size       = var.eks_dynamic_min_size
  eks_dynamic_max_size       = var.eks_dynamic_max_size

  eks_cache_instance_types = var.eks_cache_instance_types
  eks_cache_capacity_type  = var.eks_cache_capacity_type
  eks_cache_ami_type       = var.eks_cache_ami_type
  eks_cache_platform       = var.eks_cache_platform
  eks_cache_desired_count  = var.eks_cache_desired_count
  eks_cache_min_size       = var.eks_cache_min_size
  eks_cache_max_size       = var.eks_cache_max_size

  eks_db_instance_types = var.eks_db_instance_types
  eks_db_capacity_type  = var.eks_db_capacity_type
  eks_db_ami_type       = var.eks_db_ami_type
  eks_db_platform       = var.eks_db_platform
  eks_db_desired_count  = var.eks_db_desired_count
  eks_db_min_size       = var.eks_db_min_size
  eks_db_max_size       = var.eks_db_max_size

  eks_cluster_enabled_log_types = var.eks_cluster_enabled_log_types
  eks_worker_ami_name_filter    = var.eks_worker_ami_name_filter
  eks_worker_ami_owner_id       = var.eks_worker_ami_owner_id

  # External Redis Configuration
  external_redis                          = var.external_redis
  external_redis_name                     = var.external_redis_name
  ec_vpc_id                               = var.ec_vpc_id
  ec_private_subnets                      = var.ec_private_subnets
  ec_instance_type                        = var.ec_instance_type
  ec_cluster_mode_enabled                 = var.ec_cluster_mode_enabled
  ec_cluster_mode_creation_fix_enabled    = var.ec_cluster_mode_creation_fix_enabled
  ec_cluster_mode_num_node_groups         = var.ec_cluster_mode_num_node_groups
  ec_cluster_mode_replicas_per_node_group = var.ec_cluster_mode_replicas_per_node_group
  ec_cluster_size                         = var.ec_cluster_size
  ec_apply_immediately                    = var.ec_apply_immediately
  ec_automatic_failover_enabled           = var.ec_automatic_failover_enabled
  ec_engine_version                       = var.ec_engine_version
  ec_family                               = var.ec_family
  ec_at_rest_encryption_enabled           = var.ec_at_rest_encryption_enabled
  ec_parameter                            = var.ec_parameter
  ec_snapshot_name                        = var.ec_snapshot_name
  ec_snapshot_retention_limit             = var.ec_snapshot_retention_limit
  ec_snapshot_window                      = var.ec_snapshot_window
  ec_transit_encryption_enabled           = var.ec_transit_encryption_enabled
  ec_subnet_single_az                     = var.ec_subnet_single_az

  # External Database Configuration
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
  rds_snapshot_identifier                      = var.rds_snapshot_identifier
  rds_deletion_protection                      = var.rds_deletion_protection
  rds_performance_insights_enabled             = var.rds_performance_insights_enabled
  rds_performance_insights_retention_period    = var.rds_performance_insights_retention_period
  rds_allocated_storage                        = var.rds_allocated_storage
  rds_storage_encrypted                        = var.rds_storage_encrypted
  rds_instance_class                           = var.rds_instance_class
  rds_backup_retention_period                  = var.rds_backup_retention_period
  rds_monitoring_interval                      = var.rds_monitoring_interval
  rds_max_allocated_storage                    = var.rds_max_allocated_storage
  rds_iops                                     = var.rds_iops
  rds_storage_type                             = var.rds_storage_type
  rds_apply_immediately                        = var.rds_apply_immediately
  rds_parameters                               = var.rds_parameters
  rds_allow_major_version_upgrade              = var.rds_allow_major_version_upgrade
  rds_manage_master_user_password              = var.rds_manage_master_user_password
  rds_ca_cert_identifier                       = var.rds_ca_cert_identifier
  default_tags                                 = var.default_tags
  tags                                         = var.tags

  vpc_custom_service_name                  = var.vpc_custom_service_name
  vpc_specific_subnet_newbits              = var.vpc_specific_subnet_newbits
  ec_appautoscaling_predefined_metric_type = var.ec_appautoscaling_predefined_metric_type
  ec_appautoscaling_target_value           = var.ec_appautoscaling_target_value
  ec_appautoscaling_policy_type            = var.ec_appautoscaling_policy_type
  ec_appautoscaling_target_min_capacity    = var.ec_appautoscaling_target_min_capacity
  ec_appautoscaling_target_max_capacity    = var.ec_appautoscaling_target_max_capacity
  ec_appautoscaling_scalable_dimension     = var.ec_appautoscaling_scalable_dimension
  ec_appautoscaling_scale_in_cooldown      = var.ec_appautoscaling_scale_in_cooldown
  ec_appautoscaling_scale_out_cooldown     = var.ec_appautoscaling_scale_out_cooldown
  ec_enable_app_autoscaling                = var.ec_enable_app_autoscaling
  ec_allow_all_egress                      = var.ec_allow_all_egress
  ec_data_tiering_enabled                  = var.ec_data_tiering_enabled

  # cluster autoscaler
  cluster_autoscaler_enabled = var.cluster_autoscaler_enabled
  cluster_autoscaler_verbosity_level = var.cluster_autoscaler_verbosity_level
  cluster_autoscaler_namespace = var.cluster_autoscaler_namespace
  cluster_autoscaler_helm_chart_version = var.cluster_autoscaler_helm_chart_version
  cluster_autoscaler_image_tag = var.cluster_autoscaler_image_tag
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
  value = module.edge-aws.endpoint_address
}

output "pinky_ingress_id" {
  value = module.edge-aws.pinky_ingress_id
}

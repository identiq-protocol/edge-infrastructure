provider "azurerm" {
  features {}
}

#terraform {
#  backend "azurerm" {
#    resource_group_name  = "StorageAccount-ResourceGroup"
#    storage_account_name = "identiq"
#    container_name       = "terraform-state"
#    key                  = "prod.terraform.tfstate"
#  }
#}

module "edge-azure" {
  source = "git@github.com:identiq-protocol/edge-infrastructure.git//modules/azure/?ref=0.0.74"

  # Azure ad
  ad_application_dispaly_name = var.ad_application_dispaly_name

  # Network
  address_space                       = var.address_space
  nat_gateway_idle_timeout_in_minutes = var.nat_gateway_idle_timeout_in_minutes
  nat_gateway_sku_name                = var.nat_gateway_sku_name
  public_ip_prefix_prefix_length      = var.public_ip_prefix_prefix_length

  # AKS
  aks_cluster_name                     = var.aks_cluster_name
  aks_kubernetes_version               = var.aks_kubernetes_version
  aks_prefix                           = var.aks_prefix
  aks_default_agents_max_pods          = var.aks_default_agents_max_pods
  aks_default_agents_node_count        = var.aks_default_agents_node_count
  aks_default_agents_node_min_count    = var.aks_default_agents_node_min_count
  aks_default_agents_os_disk_size_gb   = var.aks_default_agents_os_disk_size_gb
  aks_default_agents_vm_size           = var.aks_default_agents_vm_size
  aks_db_agents_max_pods               = var.aks_db_agents_max_pods
  aks_db_agents_node_count             = var.aks_db_agents_node_count
  aks_db_agents_node_min_count         = var.aks_db_agents_node_min_count
  aks_db_agents_os_disk_size_gb        = var.aks_db_agents_os_disk_size_gb
  aks_db_agents_vm_size                = var.aks_db_agents_vm_size
  aks_cache_agents_max_pods            = var.aks_cache_agents_max_pods
  aks_cache_agents_node_count          = var.aks_cache_agents_node_count
  aks_cache_agents_node_min_count      = var.aks_cache_agents_node_min_count
  aks_cache_agents_os_disk_size_gb     = var.aks_cache_agents_os_disk_size_gb
  aks_cache_agents_vm_size             = var.aks_cache_agents_vm_size
  aks_base_agents_max_pods             = var.aks_base_agents_max_pods
  aks_base_agents_node_count           = var.aks_base_agents_node_count
  aks_base_agents_node_min_count       = var.aks_base_agents_node_min_count
  aks_base_agents_os_disk_size_gb      = var.aks_base_agents_os_disk_size_gb
  aks_base_agents_vm_size              = var.aks_base_agents_vm_size
  aks_dynamic_agents_max_pods          = var.aks_dynamic_agents_max_pods
  aks_dynamic_agents_node_count        = var.aks_dynamic_agents_node_count
  aks_dynamic_agents_node_min_count    = var.aks_dynamic_agents_node_min_count
  aks_dynamic_agents_os_disk_size_gb   = var.aks_dynamic_agents_os_disk_size_gb
  aks_dynamic_agents_vm_size           = var.aks_dynamic_agents_vm_size
  aks_enable_log_analytics_workspace   = var.aks_enable_log_analytics_workspace
  aks_enable_role_based_access_control = var.aks_enable_role_based_access_control
  aks_net_profile_dns_service_ip       = var.aks_net_profile_dns_service_ip
  aks_net_profile_docker_bridge_cidr   = var.aks_net_profile_docker_bridge_cidr
  aks_net_profile_service_cidr         = var.aks_net_profile_service_cidr
  aks_network_plugin                   = var.aks_network_plugin
  aks_network_policy                   = var.aks_network_policy
  aks_private_cluster_enabled          = var.aks_private_cluster_enabled
  aks_rbac_aad_managed                 = var.aks_rbac_aad_managed
  aks_sku_tier                         = var.aks_sku_tier

  # Postgresql
  external_db                                = var.external_db
  postgresql_client_name                     = var.postgresql_client_name
  postgresql_administrator_login             = var.postgresql_administrator_login
  postgresql_allowed_cidrs                   = var.postgresql_allowed_cidrs
  postgresql_auto_grow_enabled               = var.postgresql_auto_grow_enabled
  postgresql_backup_retention_days           = var.postgresql_backup_retention_days
  postgresql_configurations                  = var.postgresql_configurations
  postgresql_databases_charset               = var.postgresql_databases_charset
  postgresql_databases_collation             = var.postgresql_databases_collation
  postgresql_databases_names                 = var.postgresql_databases_names
  postgresql_enable_logs_to_log_analytics    = var.postgresql_enable_logs_to_log_analytics
  postgresql_enable_logs_to_storage          = var.postgresql_enable_logs_to_storage
  postgresql_environment                     = var.postgresql_environment
  postgresql_force_ssl                       = var.postgresql_force_ssl
  postgresql_geo_redundant_backup_enabled    = var.postgresql_geo_redundant_backup_enabled
  postgresql_logs_log_analytics_workspace_id = var.postgresql_logs_log_analytics_workspace_id
  postgresql_logs_storage_account_id         = var.postgresql_logs_storage_account_id
  postgresql_logs_storage_retention          = var.postgresql_logs_storage_retention
  postgresql_storage_mb                      = var.postgresql_storage_mb
  postgresql_tier                            = var.postgresql_tier
  postgresql_capacity                        = var.postgresql_capacity
  postgresql_version                         = var.postgresql_version

  # Redis
  external_redis                  = var.external_redis
  redis_environment               = var.redis_environment
  redis_allow_non_ssl_connections = var.redis_allow_non_ssl_connections
  redis_sku_name                  = var.redis_sku_name
  redis_capacity                  = var.redis_capacity
  redis_authorized_cidrs          = var.redis_authorized_cidrs

  # General
  region              = var.region
  resource_group_name = var.resource_group_name
  default_tags        = var.default_tags
  tags                = var.tags
}

output "connect" {
  value = module.edge-azure.connect
}

output "nat_ip" {
  value = module.edge-azure.nat_ip
}

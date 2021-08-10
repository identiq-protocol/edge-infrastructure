resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
  tags     = merge(var.tags, var.default_tags)
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  subnet_prefixes     = local.subnet_prefixes
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  subnet_enforce_private_link_endpoint_network_policies = {
    "subnet2" = true,
    "subnet3" = true
  }
  tags       = merge(var.tags, var.default_tags)
  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_public_ip_prefix" "nat_ip" {
  name                = "${var.aks_cluster_name}-nat-gateway-publicIPPrefix"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = var.public_ip_prefix_prefix_length
  availability_zone   = 1
  tags                = merge(var.tags, var.default_tags)
}

resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.aks_cluster_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = var.nat_gateway_sku_name
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout_in_minutes
  zones                   = ["1"]
  tags                    = merge(var.tags, var.default_tags)
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "example" {
  nat_gateway_id      = azurerm_nat_gateway.nat_gw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_a" {
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
  subnet_id      = module.network.vnet_subnets[0]
}

module "aks" {
  source                           = "Azure/aks/azurerm"
  resource_group_name              = azurerm_resource_group.rg.name
  kubernetes_version               = var.aks_kubernetes_version
  orchestrator_version             = var.aks_kubernetes_version
  client_id                        = azuread_application.app.application_id
  client_secret                    = azuread_service_principal_password.app.value
  prefix                           = var.aks_prefix
  cluster_name                     = var.aks_cluster_name
  network_plugin                   = var.aks_network_plugin
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  sku_tier                         = var.aks_sku_tier
  enable_role_based_access_control = var.aks_enable_role_based_access_control
  rbac_aad_managed                 = var.aks_rbac_aad_managed
  private_cluster_enabled          = var.aks_private_cluster_enabled
  enable_log_analytics_workspace   = var.aks_enable_log_analytics_workspace
  network_policy                   = var.aks_network_policy
  net_profile_dns_service_ip       = var.aks_net_profile_dns_service_ip
  net_profile_docker_bridge_cidr   = var.aks_net_profile_docker_bridge_cidr
  net_profile_service_cidr         = var.aks_net_profile_service_cidr
  # "default" node pool
  agents_pool_name          = "default"
  os_disk_size_gb           = var.aks_default_agents_os_disk_size_gb
  agents_size               = var.aks_default_agents_vm_size
  enable_auto_scaling       = var.aks_default_enable_auto_scaling
  agents_min_count          = var.aks_default_enable_auto_scaling ? var.aks_default_agents_node_min_count : null
  agents_max_count          = var.aks_default_enable_auto_scaling ? var.aks_default_agents_node_count : null
  agents_count              = var.aks_default_agents_node_count
  agents_max_pods           = var.aks_default_agents_max_pods
  agents_availability_zones = ["1"]
  agents_labels = {
    "nodepool" = "defaultnodepool"
  }
  agents_tags = merge(var.tags, var.default_tags)
  depends_on  = [module.network, azuread_application.app]
}

resource "azurerm_kubernetes_cluster_node_pool" "db" {
  name                  = "db"
  count                 = var.external_db ? 0 : 1
  kubernetes_cluster_id = module.aks.aks_id
  os_disk_size_gb       = var.aks_db_agents_os_disk_size_gb
  vm_size               = var.aks_db_agents_vm_size
  enable_auto_scaling   = var.aks_db_enable_auto_scaling
  min_count             = var.aks_db_enable_auto_scaling ? var.aks_db_agents_node_min_count : null
  max_count             = var.aks_db_enable_auto_scaling ? var.aks_db_agents_node_count : null
  node_count            = var.aks_db_agents_node_count
  max_pods              = var.aks_db_agents_max_pods
  orchestrator_version  = var.aks_kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "db"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
  tags = merge(var.tags, var.default_tags)
}

resource "azurerm_kubernetes_cluster_node_pool" "cache" {
  name                  = "cache"
  count                 = var.external_redis ? 0 : 1
  kubernetes_cluster_id = module.aks.aks_id
  os_disk_size_gb       = var.aks_cache_agents_os_disk_size_gb
  vm_size               = var.aks_cache_agents_vm_size
  enable_auto_scaling   = var.aks_cache_enable_auto_scaling
  min_count             = var.aks_cache_enable_auto_scaling ? var.aks_cache_agents_node_min_count : null
  max_count             = var.aks_cache_enable_auto_scaling ? var.aks_cache_agents_node_count : null
  node_count            = var.aks_cache_agents_node_count
  max_pods              = var.aks_cache_agents_max_pods
  orchestrator_version  = var.aks_kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "cache"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
  tags = merge(var.tags, var.default_tags)
}

resource "azurerm_kubernetes_cluster_node_pool" "dynamic" {
  name                  = "dynamic"
  kubernetes_cluster_id = module.aks.aks_id
  os_disk_size_gb       = var.aks_dynamic_agents_os_disk_size_gb
  vm_size               = var.aks_dynamic_agents_vm_size
  enable_auto_scaling   = var.aks_dynamic_enable_auto_scaling
  min_count             = var.aks_dynamic_enable_auto_scaling ? var.aks_dynamic_agents_node_min_count : null
  max_count             = var.aks_dynamic_enable_auto_scaling ? var.aks_dynamic_agents_node_count : null
  node_count            = var.aks_dynamic_agents_node_count
  max_pods              = var.aks_dynamic_agents_max_pods
  orchestrator_version  = var.aks_kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "dynamic"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
  tags = merge(var.tags, var.default_tags)
}

resource "azurerm_kubernetes_cluster_node_pool" "base" {
  name                  = "base"
  kubernetes_cluster_id = module.aks.aks_id
  os_disk_size_gb       = var.aks_base_agents_os_disk_size_gb
  vm_size               = var.aks_base_agents_vm_size
  enable_auto_scaling   = var.aks_base_enable_auto_scaling
  min_count             = var.aks_base_enable_auto_scaling ? var.aks_base_agents_node_min_count : null
  max_count             = var.aks_base_enable_auto_scaling ? var.aks_base_agents_node_count : null
  node_count            = var.aks_base_agents_node_count
  max_pods              = var.aks_base_agents_max_pods
  orchestrator_version  = var.aks_kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "base"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
  tags = merge(var.tags, var.default_tags)
}

provider "kubernetes" {
  host                   = module.aks.admin_host
  cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.admin_client_certificate)
  client_key             = base64decode(module.aks.admin_client_key)
}

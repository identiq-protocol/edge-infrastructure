resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.region
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
  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_public_ip_prefix" "nat_ip" {
  name                = "${var.cluster_name}-nat-gateway-publicIPPrefix"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 31
  availability_zone   = 1
}

resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.cluster_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.nat_ip.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_a" {
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
  subnet_id      = module.network.vnet_subnets[0]
}

module "aks" {
  source                           = "Azure/aks/azurerm"
  resource_group_name              = azurerm_resource_group.rg.name
  kubernetes_version               = var.kubernetes_version
  orchestrator_version             = var.kubernetes_version
  client_id                        = azuread_application.app.application_id
  client_secret                    = azuread_service_principal_password.app.value
  prefix                           = var.cluster_prefix
  cluster_name                     = var.cluster_name
  network_plugin                   = var.network_plugin
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = var.os_disk_size_gb
  sku_tier                         = var.sku_tier
  enable_role_based_access_control = var.enable_role_based_access_control
  rbac_aad_managed                 = var.rbac_aad_managed
  private_cluster_enabled          = var.private_cluster_enabled # default value
  enable_log_analytics_workspace   = var.enable_log_analytics_workspace
  agents_size			   = var.aks_default_agent_size
  agents_size                      = "Standard_A2_v2"
  agents_min_count                 = 1
  agents_max_count                 = 1
  agents_count                     = 1
  agents_max_pods                  = var.agents_max_pods
  agents_pool_name                 = "default"
  agents_availability_zones        = ["1"]
  agents_labels = {
    "nodepool" = "defaultnodepool"
  }
  network_policy                 = var.network_policy
  net_profile_dns_service_ip     = var.net_profile_dns_service_ip
  net_profile_docker_bridge_cidr = var.net_profile_docker_bridge_cidr
  net_profile_service_cidr       = var.net_profile_service_cidr
  depends_on                     = [module.network, azuread_application.app]
}

resource "azurerm_kubernetes_cluster_node_pool" "db" {
  name                  = substr("${var.cluster_name}db", 0, 10)
  count                 = var.external_store ? 0 : 1
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = "Standard_B4ms"
  node_count            = 1
  os_disk_size_gb       = var.os_disk_size_gb
  orchestrator_version  = var.kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "db"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "cache" {
  name                  = substr("${var.cluster_name}cache", 0, 10)
  count                 = var.external_store ? 0 : 1
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = var.aks_cache_vm_size
  node_count            = var.aks_cache_node_count
  os_disk_size_gb       = var.aks_os_disk_size_gb
  orchestrator_version  = var.aks_kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "cache"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "base" {
  name                  = substr("${var.cluster_name}base", 0, 10)
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = var.base_agents_size
  node_count            = var.base_agents_count != 0 ? var.base_agents_count : 1
  os_disk_size_gb       = var.os_disk_size_gb
  orchestrator_version  = var.kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "base"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "dynamic" {
  name                  = substr("${var.cluster_name}dynamic", 0, 10)
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = var.dynamic_agents_size
  node_count            = var.dynamic_agents_count != 0 ? var.dynamic_agents_count : 1
  os_disk_size_gb       = var.os_disk_size_gb
  orchestrator_version  = var.kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "dynamic"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
}

provider "kubernetes" {
  host                   = module.aks.admin_host
  cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.admin_client_certificate)
  client_key             = base64decode(module.aks.admin_client_key)
}

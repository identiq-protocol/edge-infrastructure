provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.region
}

module "network" {
  source                                                = "Azure/network/azurerm"
  resource_group_name                                   = azurerm_resource_group.rg.name
  address_space                                         = "10.0.0.0/16"
  subnet_prefixes                                       = ["10.0.4.0/22"]
  subnet_names                                          = ["subnet1"]
  subnet_enforce_private_link_endpoint_network_policies = { "subnet1" : true }
  depends_on                                            = [azurerm_resource_group.rg]
}

resource "azurerm_public_ip_prefix" "nat_ip" {
  name                = "${var.cluster_name}-nat-gateway-publicIPPrefix"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 31
  zones               = ["1"]
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
terraform {
  backend "s3" {
    region  = "us-east-1"
    bucket  = "identiq-production-terraform"
    key     = "dev/azure/edge-infrastructure"
    encrypt = "true"
  }
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

  depends_on = [module.network]
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
  vm_size               = var.cache_agent_size
  node_count            = 1
  os_disk_size_gb       = var.os_disk_size_gb
  orchestrator_version  = var.kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "cache"
  }
  lifecycle {
    ignore_changes = [node_labels]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "comp" {
  name                  = substr("${var.cluster_name}comp", 0, 10)
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = var.agents_size
  node_count            = var.agents_count != 0 ? var.agents_count : 1
  os_disk_size_gb       = var.os_disk_size_gb
  orchestrator_version  = var.kubernetes_version
  vnet_subnet_id        = module.network.vnet_subnets[0]
  node_labels = {
    "edge.identiq.com/role" = "components"
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

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
  network_plugin                   = "azure"
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = 50
  sku_tier                         = "Paid"
  enable_role_based_access_control = true
  rbac_aad_managed                 = true
  private_cluster_enabled          = false # default value
  enable_log_analytics_workspace   = false
  agents_size                      = var.agents_size
  agents_min_count                 = 1
  agents_max_count                 = var.agents_count
  agents_count                     = var.agents_count
  agents_max_pods                  = 100
  agents_pool_name                 = "node"
  agents_availability_zones        = ["1"]
  agents_labels = {
    "nodepool" : "defaultnodepool"
  }
  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.30.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.30.0.0/24"

  depends_on = [module.network]
}
provider "kubernetes" {
  host                   = module.aks.admin_host
  cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.admin_client_certificate)
  client_key             = base64decode(module.aks.admin_client_key)

}

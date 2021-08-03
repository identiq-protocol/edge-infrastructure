provider "azurerm" {
  features {}
}

module "edge-azure" {
  source               = "../../modules/azure"
  cluster_name         = var.cluster_name
  region               = var.region
  base_agents_count    = var.base_agents_count
  base_agents_size     = var.base_agents_size
  dynamic_agents_count = var.dynamic_agents_count
  dynamic_agents_size  = var.dynamic_agents_size
  cache_agent_size     = var.cache_agent_size
  external_store       = var.external_store
}

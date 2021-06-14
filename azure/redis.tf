module "redis" {
  count                     = var.external_store ? 1 : 0
  source                    = "claranet/redis/azurerm"
  client_name               = var.cluster_name
  environment               = "production"
  location                  = var.region
  location_short            = var.region
  resource_group_name       = azurerm_resource_group.rg.name
  stack                     = var.cluster_name
  allow_non_ssl_connections = true
  subnet_id                 = module.network.vnet_subnets[1]
  #private_static_ip_address = cidrhost(module.network.vnet_address_space[0],4)
  #private_static_ip_address = module.network.vnet_address_space[0]
  private_static_ip_address = "10.0.5.6"
  authorized_cidrs = {
    ip1 = "10.0.0.0/16"
  }
  depends_on = [module.network, azuread_application.app]
}

#resource "azurerm_private_endpoint" "redis_private_endpoint" {
#  count               = var.external_store ? 1 : 0
#  name                = "redis-private-endpoint"
#  location            = var.region
#  resource_group_name = azurerm_resource_group.rg.name
#  subnet_id           = module.network.vnet_subnets[1]
#
#  private_service_connection {
#    name = "redis-private-privateserviceconnection"
#    private_connection_resource_id = module.redis[0].redis_id
#    subresource_names              = ["redisServer"]
#    is_manual_connection           = false
#  }
#  depends_on = [
#    module.aks,
#    module.redis[0]
#  ]
#
#}

resource "kubernetes_secret" "edge_redis_secret" {
  count = var.external_store ? 1 : 0
  metadata {
    name = "edge-identities-redis"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"%%host%%\",\"port\":\"6379\",\"password\":\"%%env_REDIS_PASSWORD%%\"}]"
    }
  }
  data = {
    redis-password = module.redis[0].redis_primary_access_key
  }
  depends_on = [
    module.aks,
    module.redis[0]
  ]
}

resource "kubernetes_service" "edge_redis_service" {
  count = var.external_store ? 1 : 0
  metadata {
    name = "edge-identities-redis-master"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"%%host%%\",\"port\":\"6379\",\"password\":\"%%env_REDIS_PASSWORD%%\"}]"
    }
  }
  spec {
    type = "ExternalName"
    #external_name = module.redis[0].redis_hostname
    #external_name = azurerm_private_endpoint.redis_private_endpoint[0].private_service_connection[0].private_ip_address
    external_name = module.redis[0].redis_private_static_ip_address
  }
  depends_on = [
    module.aks,
    module.redis[0]
    #azurerm_private_endpoint.redis_private_endpoint
  ]
}

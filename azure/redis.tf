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
  subnet_id                 = module.network.vnet_subnets[0]
  authorized_cidrs = {
    ip1 = "10.0.0.0/16"
  }
}

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
    redis-password = ""
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
    type          = "ExternalName"
    external_name = module.redis[0].redis_hostname
  }
  depends_on = [
    module.aks,
    module.redis[0]
  ]
}

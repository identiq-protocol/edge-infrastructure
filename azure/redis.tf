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
  private_static_ip_address = cidrhost(local.subnet_prefixes[1], 4)
  authorized_cidrs = {
    ip1 = "10.0.0.0/16"
  }
  depends_on = [module.network, azuread_application.app]
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
    redis-password = module.redis[0].redis_primary_access_key
  }
  depends_on = [
    module.aks,
    module.redis[0]
  ]
}

resource "kubernetes_endpoints" "external-redis-endpoint" {
  count = var.external_store ? 1 : 0
  metadata {
    name = "edge-identities-redis-master"
  }

  subset {
    address {
      ip = module.redis[0].redis_private_static_ip_address
    }

    port {
      name = "redis"
      port = 6379
    }
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
    port {
      name        = "redis"
      protocol    = "TCP"
      port        = 6379
      target_port = 6379
    }
  }
  depends_on = [
    module.aks,
    module.redis[0]
  ]
}

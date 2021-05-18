module "redis" {
  count = var.external_store ?  1 : 0
  source                               = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=master"
  availability_zones                   = ["us-east-1a","us-east-1b","us-east-1c"]
  name                                 = var.store_name
  zone_id                              = ""
  vpc_id                               = module.vpc.vpc_id
  allowed_security_groups              = [module.my-cluster.worker_security_group_id]
  subnets                              = module.vpc.private_subnets
  cluster_mode_enabled                 = false
  security_group_description = "Managed by Terraform"
  cluster_mode_replicas_per_node_group = 0
  cluster_size = 1
  instance_type                        = "cache.${var.cache_instance_type}"
  apply_immediately                    = true
  automatic_failover_enabled           = false
  engine_version                       = "6.x"
  family                               = "redis6.x"
  at_rest_encryption_enabled           = "true"
  transit_encryption_enabled           = "false"
  tags = var.tags
}
resource "kubernetes_secret" "edge_redis_secret" {
  count = var.external_store ?  1 : 0
  metadata {
    name = "edge-identities-redis"
    annotations = {
      "ad.datadoghq.com/service.check_names" = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances" = "[{\"host\":\"%%host%%\",\"port\":\"6379\",\"password\":\"%%env_REDIS_PASSWORD%%\"}]"
    }
  }
  data = {
    redis-password = ""
  }
  depends_on = [
    module.my-cluster,
    module.redis[0]
  ]
}
resource "kubernetes_service" "edge_redis_service" {
  count = var.external_store ?  1 : 0
  metadata {
    name = "edge-identities-redis-master"
    annotations = {
      "ad.datadoghq.com/service.check_names" = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances" = "[{\"host\":\"%%host%%\",\"port\":\"6379\",\"password\":\"%%env_REDIS_PASSWORD%%\"}]"
    }
  }
  spec {
    type = "ExternalName"
    external_name = module.redis[0].endpoint
  }
  depends_on = [
    module.my-cluster,
    module.redis[0]
  ]
}

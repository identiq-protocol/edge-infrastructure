module "memorystore-redis" {
  count                   = var.external_redis ? 1 : 0
  source                  = "terraform-google-modules/memorystore/google"
  version                 = "7.0.0"
  name                    = var.cluster_name
  project                 = var.project_id
  memory_size_gb          = var.external_redis_memory_size_gb
  region                  = var.region
  labels                  = merge(var.default_tags, var.tags)
  redis_version           = var.external_redis_version
  location_id             = data.google_compute_zones.available.names[0]
  redis_configs           = var.external_redis_configs
  tier                    = var.external_redis_tier
  transit_encryption_mode = "DISABLED"
  authorized_network      = module.vpc.network_name
}
resource "kubernetes_secret" "edge_redis_secret" {
  count = var.external_redis ? 1 : 0
  metadata {
    name = "edge-identities-redis"
  }
  data = {
    redis-password = ""
  }
  depends_on = [
    module.gke,
    module.memorystore-redis[0]
  ]
}
resource "kubernetes_service" "edge_redis_service" {
  count = var.external_redis ? 1 : 0
  metadata {
    name = "edge-identities-redis-master"
  }
  spec {
    type          = "ExternalName"
    external_name = module.memorystore-redis[0].host
  }
  depends_on = [
    module.gke,
    module.memorystore-redis[0]
  ]
}

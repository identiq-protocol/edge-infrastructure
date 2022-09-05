terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.90.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.11.0"
    }
  }
}

resource "kubernetes_config_map" "version" {
  metadata {
    name = "identiq-version"
  }
  data = {
    "identiqVersion" = jsonencode(local.identiqVersion)
  }
}

locals {
  identiqVersion = {
    terraformModuleVersion = chomp(file("${path.module}/version"))
    terraformLastApplyTime = timestamp()
    cloud                  = "gcp"
    region                 = var.region
    gkeVersion             = var.gke_version
    gkeClusterName         = var.cluster_name
    networkName            = module.vpc.network_name
    networkNatIPs          = module.vpc.nat_ip
    externalRedis          = var.external_redis
    memoryStoreVersion     = var.external_redis_version
    memoryStoreSizeGb      = var.external_redis_memory_size_gb
    externalDB             = var.external_db
    pgDBVersion            = var.external_db_postgres_version
    pgInstanceType         = var.external_db_postgres_machine_type
  }
}

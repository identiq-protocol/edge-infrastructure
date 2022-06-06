terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.11.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "=2.2.0"
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
    cloud                  = "azure"
    region                 = var.region
    aksVersion             = var.aks_kubernetes_version
    aksClusterName         = var.aks_cluster_name
    rgName                 = var.resource_group_name
    vpcNatIPs              = azurerm_public_ip_prefix.nat_ip.ip_prefix
    externalRedis          = var.external_redis
    redisSKUName           = var.redis_sku_name
    redisCapacity          = var.redis_capacity
    externalDB             = var.external_db
    postgresqlVersion      = var.postgresql_version
    postgresqlCapacity     = var.postgresql_capacity
  }
}

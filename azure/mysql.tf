module "mysql" {
  source                       = "claranet/db-mysql/azurerm"
  tier                         = "GeneralPurpose"
  create_databases_users       = false
  client_name                  = var.cluster_name
  environment                  = "production"
  location                     = var.region
  location_short               = var.region
  resource_group_name          = azurerm_resource_group.rg.name
  stack                        = var.cluster_name
  allowed_cidrs                = ["10.0.0.0/24"]
  storage_mb                   = 5120
  backup_retention_days        = 10
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = false
  administrator_login          = "edge"
  administrator_password       = random_password.mysql_password[0].result
  databases_names              = ["edge"]
  force_ssl                    = true
  mysql_options                = [{ name = "interactive_timeout", value = "600" }, { name = "wait_timeout", value = "260" }]
  mysql_version                = "5.7"
  databases_charset = {
    "edge" = "utf8"
  }
  databases_collation = {
    "edge" = "utf8_general_ci"
  }
}

resource "random_password" "mysql_password" {
  count = var.external_store ?  1 : 0
  length           = 16
  special          = true
}

resource "kubernetes_secret" "edge_mariadb_secret" {
  count = var.external_store ?  1 : 0
  metadata {
    name = "edge-mariadb"
    annotations = {
      "ad.datadoghq.com/service.check_names" = "[\"mysql\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances" = "[{\"server\": \"%%host%%\", \"user\": \"edge\", \"pass\": \"%%env_MYSQL_PASS%%\", \"options\": {\"schema_size_metrics\": \"true\"}}]"
    }
  }
  data = {
    mariadb-password = random_password.mysql_password[0].result
    mariadb-root-password = random_password.mysql_password[0].result
  }

  depends_on = [
    module.aks,
    module.mysql
  ]
}

resource "kubernetes_service" "edge_mariadb_service" {
  count = var.external_store ?  1 : 0
  metadata {
    name = "edge-mariadb"
    annotations = {
      "ad.datadoghq.com/service.check_names" = "[\"mysql\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances" = "[{\"server\": \"%%host%%\", \"user\": \"edge\", \"pass\": \"%%env_MYSQL_PASS%%\", \"options\": {\"schema_size_metrics\": \"true\"}}]"
    }
  }

  spec {
    type = "ExternalName"
    external_name = module.mysql.mysql_fqdn
  }

  depends_on = [
    module.aks,
    module.mysql
  ]
}

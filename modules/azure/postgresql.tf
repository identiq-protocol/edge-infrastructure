resource "random_password" "db_password" {
  count   = var.external_db ? 1 : 0
  length  = 16
  special = true
}

module "postgresql" {
  count               = var.external_db ? 1 : 0
  source              = "../terraform-azurerm-db-postgresql"
  tier                = var.postgresql_tier
  capacity 	      = var.postgresql_capacity
  force_ssl           = var.postgresql_force_ssl
  client_name         = var.aks_cluster_name
  environment         = var.postgresql_environment
  location            = var.region
  location_short      = var.region
  resource_group_name = azurerm_resource_group.rg.name
  stack               = var.aks_cluster_name

  postgresql_version              = var.postgresql_version
  allowed_cidrs                   = var.postgresql_allowed_cidrs
  storage_mb                      = var.postgresql_storage_mb
  backup_retention_days           = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled    = var.postgresql_geo_redundant_backup_enabled
  auto_grow_enabled               = var.postgresql_auto_grow_enabled
  databases_names                 = var.postgresql_databases_names
  postgresql_configurations       = var.postgresql_configurations
  databases_charset               = var.postgresql_databases_charset
  databases_collation             = var.postgresql_databases_collation
  enable_logs_to_storage          = var.postgresql_enable_logs_to_storage
  enable_logs_to_log_analytics    = var.postgresql_enable_logs_to_log_analytics
  logs_storage_retention          = var.postgresql_logs_storage_retention
  logs_storage_account_id         = var.postgresql_logs_storage_account_id
  logs_log_analytics_workspace_id = var.postgresql_logs_log_analytics_workspace_id
  administrator_login             = var.postgresql_administrator_login
  administrator_password          = random_password.db_password[0].result
  extra_tags                      = merge(var.tags, var.default_tags)

  depends_on = [module.network, azuread_application.app]
}

resource "azurerm_private_endpoint" "db_private_endpoint" {
  count               = var.external_db ? 1 : 0
  name                = "${var.aks_cluster_name}-db-private-endpoint"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.vnet_subnets[2]

  private_service_connection {
    name                           = "db-private-service-connection"
    private_connection_resource_id = module.postgresql[0].postgresql_server_id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
  depends_on = [
    module.aks,
    module.postgresql[0]
  ]

}

resource "kubernetes_secret" "edge_db_secret" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-postgresql"
  }
  data = {
    postgresql-user          = "${var.postgresql_administrator_login}@${module.postgresql[0].postgresql_fqdn}"
    postgresql-password      = random_password.db_password[0].result
    postgresql-root-password = random_password.db_password[0].result
  }

  depends_on = [
    module.aks,
    module.postgresql[0]
  ]
}

resource "kubernetes_endpoints" "external-db-endpoint" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-postgresql"
  }

  subset {
    address {
      ip = azurerm_private_endpoint.db_private_endpoint[0].private_service_connection[0].private_ip_address
    }

    port {
      name = "postgresql"
      port = 5432
    }
  }
  depends_on = [
    module.aks,
    azurerm_private_endpoint.db_private_endpoint
  ]
}

resource "kubernetes_service" "edge_db_service" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-postgresql"
  }

  spec {
    port {
      name        = "postgresql"
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }
  }

  depends_on = [
    module.aks,
    azurerm_private_endpoint.db_private_endpoint
  ]
}

### CloudSQL - postgres ###
module "postgresql-db" {
  count   = var.external_db ? 1 : 0
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "13.0.1"
  name    = var.cluster_name
  database_flags = var.external_db_database_flags
  random_instance_name = true
  user_name            = var.external_db_user_name
  database_version     = var.external_db_postgres_version
  project_id           = var.project_id
  zone                 = data.google_compute_zones.available.names[0]
  region               = var.region
  tier                 = var.external_db_postgres_machine_type
  disk_size            = var.external_db_postgres_disk_size
  disk_autoresize      = var.external_db_postgres_disk_autoresize
  user_labels          = merge(var.default_tags, var.tags)
  deletion_protection  = var.external_db_deletion_protection
  backup_configuration = var.external_db_postgres_backup_configuration
  ip_configuration = {
    ipv4_enabled        = true
    private_network     = module.vpc.network_id
    require_ssl         = false
    authorized_networks = var.external_db_authorized_networks
    allocated_ip_range  = null
  }
  depends_on = [module.private-service-access]
}

resource "kubernetes_secret" "edge_db_secret" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-postgresql"
  }
  data = {
    "postgresql-password"      = module.postgresql-db[0].generated_user_password
    "postgresql-root-password" = module.postgresql-db[0].generated_user_password
    "connection-name"          = module.postgresql-db[0].instance_connection_name
  }

  depends_on = [
    module.gke,
    module.postgresql-db[0]
  ]
}

resource "kubernetes_service" "edge_db_service" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-postgresql"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"postgres\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"edge-postgresql\",\"username\":\"edge\",\"password\":\"%%env_PGSQL_PASS%%\",\"ignore_databases\":[],\"collect_activity_metrics\":\"true\",\"collect_default_database\":\"true\",\"dbm\":\"true\",\"query_metrics\":{\"enabled\":\"true\"}}]"
    }
  }

  spec {
    type          = "ExternalName"
    external_name = module.postgresql-db[0].private_ip_address
  }

  depends_on = [
    module.gke,
    module.postgresql-db[0]
  ]
}


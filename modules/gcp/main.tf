data "google_compute_zones" "available" {
  provider = google-beta
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region
  project_id = var.project_id
  vpc_name = var.vpc_name
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "16.0.1"
  project_id                        = var.project_id
  name                              = var.cluster_name
  region                            = var.region
  zones                             = var.zones
  network                           = module.vpc.network_name
  subnetwork                        = module.vpc.subnetwork_name
  ip_range_pods                     = var.gke_ip_range_pods
  ip_range_services                 = var.gke_ip_range_services
  create_service_account            = true
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = false
  cluster_autoscaling               = var.gke_cluster_autoscaling
  enable_private_nodes              = var.gke_enable_private_nodes
  add_master_webhook_firewall_rules = true
  firewall_inbound_ports            = ["1-65535"]
  kubernetes_version = var.gke_version
  cluster_resource_labels = merge(var.default_tags, var.tags)

  node_pools = [
    {
      name            = "base"
      autoscaling     = false
      node_count      = var.gke_nodegroup_base_machine_count
      service_account = var.compute_engine_service_account
      machine_type    = var.gke_nodegroup_base_machinetype
      node_locations  = data.google_compute_zones.available.names[0]
      auto_upgrade    = false
    },
    {
      name            = "dynamic"
      autoscaling     = false
      node_count      = var.gke_nodegroup_dynamic_machine_count
      service_account = var.compute_engine_service_account
      machine_type    = var.gke_nodegroup_dynamic_machinetype
      node_locations  = data.google_compute_zones.available.names[0]
      auto_upgrade    = false
    },
    {
      name            = "cache"
      autoscaling     = false
      node_count      = var.external_redis ? 0 : var.gke_nodegroup_cache_machine_count
      service_account = var.compute_engine_service_account
      machine_type    = var.gke_nodegroup_cache_machinetype
      node_locations  = data.google_compute_zones.available.names[0]
      auto_upgrade    = false
    },
    {
      name            = "db"
      autoscaling     = false
      node_count      = var.external_db ? 0 : var.gke_nodegroup_db_machine_count
      service_account = var.compute_engine_service_account
      machine_type    = var.gke_nodegroup_db_machinetype
      node_locations  = data.google_compute_zones.available.names[0]
      auto_upgrade    = false
    },
  ]

  node_pools_metadata = {
    all = {
      shutdown-script = file("${path.module}/data/shutdown-script.sh")
    }
  }

  node_pools_labels = {
    base = {
      "edge.identiq.com/role" = "base"
    }
    dynamic = {
      "edge.identiq.com/role" = "dynamic"
    }
    cache = {
      "edge.identiq.com/role" = "cache"
    }
    db = {
      "edge.identiq.com/role" = "db"
    }
  }
}

module "private-service-access" {
  count       = var.external_db || var.external_redis ? 1 : 0
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "6.0.0"
  project_id  = var.project_id
  vpc_network = module.vpc.network_name
  depends_on  = [module.vpc]
}

module "postgresql-db" {
  count       = var.external_db ? 1 : 0
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "6.0.0"
  name = var.cluster_name
  random_instance_name = true
  user_name = var.external_db_user_name
  database_version = var.external_db_postgres_version
  project_id = var.project_id
  zone = data.google_compute_zones.available.names[0]
  region = var.region
  tier = var.external_db_postgres_machine_type
  disk_size = var.external_db_postgres_disk_size
  disk_autoresize = var.external_db_postgres_disk_autoresize
  user_labels = merge(var.default_tags, var.tags)
  deletion_protection = var.external_db_deletion_protection
  ip_configuration = {
    ipv4_enabled = true
    private_network = module.vpc.network_id
    require_ssl = false
    authorized_networks = var.external_db_authorized_networks
  }
  depends_on  = [module.private-service-access]
}
data "google_client_config" "provider" {}
data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id
}
provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke_cluster.endpoint != null ? data.google_container_cluster.gke_cluster.endpoint : "localhost" }"
  cluster_ca_certificate = data.google_container_cluster.gke_cluster.master_auth != null ? base64decode(
  data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  ) : ""
  token = data.google_client_config.provider.access_token
}
resource "kubernetes_secret" "edge_db_secret" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-postgresql"
  }
  data = {
    "postgresql-password"      = module.postgresql-db[0].generated_user_password
    "postgresql-root-password" = module.postgresql-db[0].generated_user_password
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

module "memorystore-redis" {
  count           = var.external_redis ? 1 : 0
  source          = "terraform-google-modules/memorystore/google"
  version         = "4.0.0"
  name            = var.cluster_name
  project         = var.project_id
  memory_size_gb  = var.external_redis_memory_size_gb
  region          = var.region
  labels          = merge(var.default_tags, var.tags)
  redis_version   = var.external_redis_version
  location_id     = data.google_compute_zones.available.names[0]
  redis_configs   = var.external_redis_configs
  tier            = var.external_redis_tier
  transit_encryption_mode = "DISABLED"
  authorized_network = module.vpc.network_name
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
resource "kubernetes_storage_class" "ssd" {
  metadata {
    name = "ssd"
    annotations = {
      "storageclass.kubernetes.io/is-default-class":"true"
    }
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-ssd"
  }
  depends_on = [module.gke]
}
resource "null_resource" "patch-standard-sc" {
  provisioner "local-exec" {
    command = <<EOT
gcloud container clusters get-credentials ${var.cluster_name} --region ${var.region} --project ${var.project_id}
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
EOT
  }
  depends_on = [module.gke]
}

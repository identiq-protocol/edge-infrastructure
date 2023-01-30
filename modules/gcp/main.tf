data "google_compute_zones" "available" {
  provider = google-beta
  project  = var.project_id
  region   = var.region
}

### VPC ###
module "vpc" {
  source                   = "./modules/vpc"
  region                   = var.region
  project_id               = var.project_id
  vpc_name                 = var.vpc_name
  vpc_nat_router_name      = var.vpc_nat_router_name
  enable_ssh_firewall_rule = var.vpc_enable_ssh_firewall_rule
}
### GKE ###
module "gke" {
  source                            = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                           = "24.1.0"
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
  kubernetes_version                = var.gke_version
  cluster_resource_labels           = merge(var.default_tags, var.tags)
  node_metadata                     = "GKE_METADATA"

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
    shutdown-script = "kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-local-data \"$HOSTNAME\"" }
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

### peering between edge's VPC network and a VPC managed by Google for MemoryStore and or CloudSQL with private ip ###
module "private-service-access" {
  count       = var.external_db || var.external_redis ? 1 : 0
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version     = "13.0.1"
  project_id  = var.project_id
  vpc_network = module.vpc.network_name
  depends_on  = [module.vpc]
}

### Kubernetes provider ###
data "google_client_config" "provider" {}
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  token                  = data.google_client_config.provider.access_token
}

### Storage Class patching ###
# Unset standard SC as default SC
# Add new SC named SSD and set it as default
resource "kubernetes_storage_class" "ssd" {
  metadata {
    name = "ssd"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "true"
    }
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-ssd"
  }
  depends_on = [module.gke]
}
resource "kubernetes_annotations" "standard" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = true
  metadata {
    name = "standard"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }
  depends_on = [module.gke]
}

terraform {
  required_version = ">= 0.12.7"
}
provider "google" {
  version = "~> 2.9.0"
  project = var.project
  region  = var.region
}

provider "google-beta" {
  version = "~> 2.9.0"
  project = var.project
  region  = var.region
}

module "gke_cluster" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.4.0"


  name = var.cluster_name

  project  = var.project
  location = var.location
  network  = module.vpc_network.network

  subnetwork                   = module.vpc_network.public_subnetwork
  cluster_secondary_range_name = module.vpc_network.public_subnetwork_secondary_range_name

  alternative_default_service_account = var.override_default_node_pool_service_account ? module.gke_service_account.email : null
}


resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "private-pool"
  project  = var.project
  location = var.location
  cluster  = module.gke_cluster.name

  initial_node_count = var.initial_node_count

  node_config {
    image_type   = "COS"
    machine_type = var.machine_type

    disk_size_gb = "50"
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = module.gke_service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

module "gke_service_account" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account?ref=v0.4.0"

  name        = var.cluster_service_account_name
  project     = var.project
  description = var.cluster_service_account_description
}

module "vpc_network" {
  source = "github.com/gruntwork-io/terraform-google-network.git//modules/vpc-network?ref=v0.2.1"

  name_prefix = "${var.cluster_name}-network-${random_string.suffix.result}"
  project     = var.project
  region      = var.region

  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block
}

# Use a random suffix to prevent overlap in network names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

output connect {
  value = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.location} --project ${var.project}"
}
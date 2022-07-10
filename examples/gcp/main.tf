#terraform {
#  backend "gcs" {
#    bucket   = ""
#    prefix      = ""
#  }
#}
module "edge-gcp" {
  source = "git@github.com:identiq-protocol/edge-infrastructure.git//modules/gcp/?ref=0.0.58"

  #gcp
  region                   = var.region
  project_id               = var.project_id
  cluster_name             = var.cluster_name
  tags                     = var.tags
  default_tags             = var.default_tags
  gke_enable_private_nodes = var.gke_enable_private_nodes

  # vpc
  vpc_name = var.vpc_name

  # gke
  gke_version = var.gke_version
  # gke nodegroups
  gke_nodegroup_base_machinetype      = var.gke_nodegroup_base_machinetype
  gke_nodegroup_base_machine_count    = var.gke_nodegroup_base_machine_count
  gke_nodegroup_dynamic_machinetype   = var.gke_nodegroup_dynamic_machinetype
  gke_nodegroup_dynamic_machine_count = var.gke_nodegroup_dynamic_machine_count
  gke_nodegroup_db_machinetype        = var.gke_nodegroup_db_machinetype
  gke_nodegroup_db_machine_count      = var.gke_nodegroup_db_machine_count
  gke_nodegroup_cache_machinetype     = var.gke_nodegroup_cache_machinetype
  gke_nodegroup_cache_machine_count   = var.gke_nodegroup_cache_machine_count

  # external db - cloud SQL
  external_db                          = var.external_db
  external_db_authorized_networks      = var.external_db_authorized_networks
  external_db_postgres_version         = var.external_db_postgres_version
  external_db_postgres_disk_size       = var.external_db_postgres_disk_size
  external_db_postgres_disk_autoresize = var.external_db_postgres_disk_autoresize
  external_db_postgres_machine_type    = var.external_db_postgres_machine_type
  external_db_deletion_protection      = var.external_db_deletion_protection
  # external redis - Memorystore
  external_redis                = var.external_redis
  external_redis_configs        = var.external_redis_configs
  external_redis_memory_size_gb = var.external_redis_memory_size_gb
  external_redis_tier           = var.external_redis_tier
  external_redis_version        = var.external_redis_version

}

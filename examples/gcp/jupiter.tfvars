region       = "us-east1"
project_id   = "default"
cluster_name = "identiq-edge"
tags = {
  owner        = "identiq"
  application  = "identiq-edge"
  cluster_name = "identiq-edge"
}
external_db = true
#external_redis = true
gke_nodegroup_base_machinetype      = "c2-standard-8"
gke_nodegroup_dynamic_machinetype   = "c2-standard-8"
gke_nodegroup_dynamic_machine_count = 6
gke_nodegroup_cache_machinetype     = "n2-custom-16-143360-ext"
external_redis_memory_size_gb       = 128

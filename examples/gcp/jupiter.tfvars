region             = "us-east1"
project_id         = "identiq-perf"
cluster_name = "edge-one"
tags = {
  owner       = "identiq"
  application = "identiq-edge"
  cluster_name = "edge-one"
  environment  = "perf"
}
external_db = true
#external_redis = true
gke_nodegroup_base_machinetype = "c2-standard-8"
gke_nodegroup_dynamic_machinetype = "c2-standard-8"
gke_nodegroup_dynamic_machine_count = 6
gke_nodegroup_cache_machinetype = "n2-highmem-16"
external_redis_memory_size_gb = 128

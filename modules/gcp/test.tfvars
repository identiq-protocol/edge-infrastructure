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
external_redis = true

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  default     = "identiq-vpc"
}
variable "region" {
  description = "The region to host all resources in"
  default = "us-east1"
}
variable "project_id" {
  description = "The project ID to host all resources in"
}
variable "default_tags" {
  description = "Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable"
  default = {
    terraform = "true"
  }
}

variable "tags" {
  description = "Any tags the user wishes to add to all resources"
  type = map(string)
}
variable "gke_zones" {
  description = "The zones for gke control plane"
  default = []
}
variable "gke_version" {
  description = "gke Kubernetes version"
  default = "1.20.9-gke.700"
}

variable "gke_nodegroup_base_machinetype" {
  description = "gke base nodegroup machine type"
  default = "c2-standard-8"
}
variable "gke_nodegroup_dynamic_machinetype" {
  description = "gke dynamic nodegroup machine type"
  default = "c2-standard-8"
}
variable "gke_nodegroup_cache_machinetype" {
  description = "gke cache nodegroup machine type"
  default = "c2-standard-8"
}
variable "gke_nodegroup_db_machinetype" {
  description = "gke db nodegroup machine type"
  default = "c2-standard-8"
}
variable "gke_nodegroup_base_machine_count" {
  description = "gke base nodegroup max count of machines"
  default = "1"
}
variable "gke_nodegroup_dynamic_machine_count" {
  description = "gke dynamic nodegroup max count of machines"
  default = "1"
}
variable "gke_nodegroup_cache_machine_count" {
  description = "gke cache nodegroup max count of machines"
  default = "1"
}
variable "gke_nodegroup_db_machine_count" {
  description = "gke db nodegroup max count of machines"
  default = "1"
}
variable "cluster_name" {
  description = "The cluster name"
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
  default = []
}

variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
  default = "default"
}

variable "gke_cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
    gpu_resources = list(object({
      resource_type = string
      minimum       = number
      maximum       = number
    }))
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
    gpu_resources       = []
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}
variable "external_db_postgres_version" {
  description = "External database(cloud SQL) postgres version"
  default = "POSTGRES_13"
}
variable "external_db_postgres_machine_type" {
  description = "External database(cloud SQL) machine type"
  default = "db-custom-2-8192"
}
variable "external_db_postgres_disk_size" {
  description = "External database(cloud SQL) disk size"
  default = "1000"
}
variable "external_db_authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}
variable "external_db" {
  description = "Whenever to create and use external cloud managed db instance"
  default = false
}
variable "external_db_user_name" {
  description = "The name of the default user for external db"
  type        = string
  default     = "edge"
}
variable "external_redis" {
  description = "Whenever to create and use external cloud managed redis instance"
  default = false
}
variable "external_redis_memory_size_gb" {
  description = "external redis(memorystore) memory size in GB per node"
  default = 64
}
variable "external_redis_version" {
  description = "external redis(memorystore) version"
  default = "REDIS_5_0"
}
variable "external_redis_configs" {
  description = "external redis(memorystore) configuration parameters"
  default = {}
}

variable "external_redis_tier" {
  description = "external redis(memorystore) service tier of the instance."
  default = "BASIC"
}

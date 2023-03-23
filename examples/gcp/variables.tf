### General variables ###
variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  default     = "identiq-vpc"
}

variable "vpc_nat_router_name" {
  description = "The name of the vpc nat router name"
  default = "nat-router"
}

variable "vpc_nat_router_name" {
  description = "The name of the vpc nat router name"
  default = "nat-router"
}

variable "vpc_enable_ssh_firewall_rule" {
  description = "create firewall rule to enable ssh access"
  default     = true
}

variable "region" {
  description = "The region to host all resources in"
  default     = "us-east1"
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
  type        = map(string)
}

### GKE variables ###
variable "gke_zones" {
  description = "The zones for gke control plane"
  default     = []
}
variable "gke_version" {
  description = "gke Kubernetes version"
  default     = "1.23.14-gke.1800"
}
variable "gke_enable_private_nodes" {
  type        = bool
  description = "(Beta) Whether nodes have internal IP addresses only"
  default     = true
}
variable "gke_nodegroup_base_machinetype" {
  description = "gke base nodegroup machine type"
  default     = "c2-standard-8"
}
variable "gke_nodegroup_dynamic_machinetype" {
  description = "gke dynamic nodegroup machine type"
  default     = "c2-standard-8"
}
variable "gke_nodegroup_cache_machinetype" {
  description = "gke cache nodegroup machine type"
  default     = "c2-standard-8"
}
variable "gke_nodegroup_db_machinetype" {
  description = "gke db nodegroup machine type"
  default     = "c2-standard-8"
}
variable "gke_nodegroup_base_machine_count" {
  description = "gke base nodegroup max count of machines"
  default     = "1"
}
variable "gke_nodegroup_dynamic_machine_count" {
  description = "gke dynamic nodegroup max count of machines"
  default     = "1"
}
variable "gke_nodegroup_cache_machine_count" {
  description = "gke cache nodegroup max count of machines"
  default     = "1"
}
variable "gke_nodegroup_db_machine_count" {
  description = "gke db nodegroup max count of machines"
  default     = "1"
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
  default     = []
}

variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
  default     = "default"
}
variable "gke_ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
  default     = ""
}

variable "gke_ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
  default     = ""
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

### External DB CloudSQL variables ###
variable "external_db" {
  description = "Whether to create and use external cloud managed db instance"
  default     = true
}
variable "external_db_postgres_version" {
  description = "External database(cloud SQL) postgres version"
  default     = "POSTGRES_13"
}
variable "external_db_postgres_machine_type" {
  description = "External database(cloud SQL) machine type"
  default     = "db-custom-2-8192"
}
variable "external_db_postgres_disk_size" {
  description = "External database(cloud SQL) disk size"
  default     = "1000"
}
variable "external_db_postgres_disk_autoresize" {
  description = "Configuration to increase Posgres storage size."
  type        = bool
  default     = true
}
variable "external_db_authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}
variable "external_db_user_name" {
  description = "The name of the default user for external db"
  type        = string
  default     = "edge"
}
variable "external_db_deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}
variable "external_db_postgres_backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = bool
    start_time                     = string
    location                       = string
    point_in_time_recovery_enabled = bool
    transaction_log_retention_days = string
    retained_backups               = number
    retention_unit                 = string
  })
  default = {
    enabled                        = true
    start_time                     = null
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 7
    retention_unit                 = null
  }
}
variable "external_db_database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = [{
    name  = "maintenance_work_mem"
    value = "4194304"
    },
    {
      name  = "checkpoint_timeout"
      value = "1800"
    },
    {
      name  = "max_wal_size"
      value = "4096"
    },
    {
      name  = "pglogical.synchronous_commit"
      value = "off"
    },
    {
      name  = "wal_buffers"
      value = "8192"
    },
    {
      name  = "enable_hashagg"
      value = "on"
  },
  ]
}

### External Identities Redis MemoryStore variables ###
variable "external_redis" {
  description = "Whenever to create and use external cloud managed redis instance"
  default     = false
}
variable "external_redis_memory_size_gb" {
  description = "external redis(memorystore) memory size in GB per node"
  default     = 64
}
variable "external_redis_version" {
  description = "external redis(memorystore) version"
  default     = "REDIS_6_X"
}
variable "external_redis_configs" {
  description = "external redis(memorystore) configuration parameters"
  default     = {}
}

variable "external_redis_tier" {
  description = "external redis(memorystore) service tier of the instance."
  default     = "BASIC"
}

variable "external_redis_transit_encryption_mode" {
  description = "The TLS mode of the Redis instance, If not provided, TLS is disabled for the instance."
  default     = "DISABLED"
}

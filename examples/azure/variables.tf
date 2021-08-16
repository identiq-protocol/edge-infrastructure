locals {
  subnet_prefixes = [cidrsubnet(var.address_space, 4, 1), cidrsubnet(var.address_space, 4, 2), cidrsubnet(var.address_space, 4, 3)]
}

variable "ad_application_dispaly_name" {
  description = "The display name for the application"
  type        = string
  default     = "identiq-sa"
}

variable "resource_group_name" {
  description = "The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created"
  type        = string
  default     = "identiq-edge"
}

variable "region" {
  description = "The Azure Region where the Resource Group (and the edge) should exist. Changing this forces a new Resource Group to be created"
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_ip_prefix_prefix_length" {
  description = "Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses). Changing this forces a new resource to be created"
  type        = number
  default     = 31
}

variable "nat_gateway_sku_name" {
  description = "The SKU which should be used. At this time the only supported value is `Standard`"
  type        = string
  default     = "Standard"
}

variable "nat_gateway_idle_timeout_in_minutes" {
  description = "The idle timeout which should be used in minutes"
  type        = number
  default     = 10
}

variable "aks_prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
  default     = "identiq"
}

variable "aks_cluster_name" {
  description = "The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'aks_prefix' var (The 'aks_prefix' var will still be applied to the dns_prefix if it is set)"
  type        = string
  default     = "edge"
}

variable "aks_kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = "1.19.11"
}

variable "aks_enable_role_based_access_control" {
  description = "AKS Enable Role Based Access Control"
  type        = bool
  default     = true
}

variable "aks_rbac_aad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration"
  type        = bool
  default     = true
}

variable "aks_private_cluster_enabled" {
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = bool
  default     = false
}

variable "aks_enable_log_analytics_workspace" {
  description = "AKS enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  type        = bool
  default     = false
}

variable "aks_network_plugin" {
  description = "AKS Network plugin to use for networking"
  type        = string
  default     = "azure"
}

variable "aks_sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Paid"
}

variable "aks_network_policy" {
  description = "Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  type        = string
  default     = "azure"
}

variable "aks_net_profile_dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created"
  type        = string
  default     = "10.30.0.10"
}

variable "aks_net_profile_docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created"
  type        = string
  default     = "170.10.0.1/16"
}

variable "aks_net_profile_service_cidr" {
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created"
  type        = string
  default     = "10.30.0.0/24"
}

variable "aks_default_agents_os_disk_size_gb" {
  description = "AKS 'default' node pool disk size of nodes in GBs"
  type        = number
  default     = 50
}

variable "aks_default_agents_vm_size" {
  description = "AKS 'default' node pool - the default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_A2_v2"
}

variable "aks_default_enable_auto_scaling" {
  description = "AKS 'default' node pool - enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "aks_default_agents_node_min_count" {
  description = "AKS 'default' node pool minimum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_default_agents_node_count" {
  description = "The number of Agents that should exist in the 'default' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes"
  type        = number
  default     = 1
}

variable "aks_default_agents_max_pods" {
  description = "The maximum number of pods that can run on each agent in 'default' node pool. Changing this forces a new resource to be created"
  type        = number
  default     = 100
}

variable "aks_db_agents_os_disk_size_gb" {
  description = "AKS 'db' node pool disk size of nodes in GBs"
  type        = number
  default     = 50
}

variable "aks_db_agents_vm_size" {
  description = "AKS 'db' node pool - the default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_D4ds_v4"
}

variable "aks_db_enable_auto_scaling" {
  description = "AKS 'db' node pool - enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "aks_db_agents_node_min_count" {
  description = "AKS 'db' node pool minimum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_db_agents_node_count" {
  description = "The number of Agents that should exist in the 'db' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes"
  type        = number
  default     = 1
}

variable "aks_db_agents_max_pods" {
  description = "The maximum number of pods that can run on each agent in 'db' node pool. Changing this forces a new resource to be created"
  type        = number
  default     = 100
}

variable "aks_cache_agents_os_disk_size_gb" {
  description = "AKS 'cache' node pool disk size of nodes in GBs"
  type        = number
  default     = 50
}

variable "aks_cache_agents_vm_size" {
  description = "AKS 'cache' node pool - the default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_E8s_v4"
}

variable "aks_cache_enable_auto_scaling" {
  description = "AKS 'cache' node pool - enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "aks_cache_agents_node_min_count" {
  description = "AKS 'cache' node pool minimum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_cache_agents_node_count" {
  description = "The number of Agents that should exist in the 'cache' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes"
  type        = number
  default     = 1
}

variable "aks_cache_agents_max_pods" {
  description = "The maximum number of pods that can run on each agent in 'cache' node pool. Changing this forces a new resource to be created"
  type        = number
  default     = 100
}

variable "aks_dynamic_agents_os_disk_size_gb" {
  description = "AKS 'dynamic' node pool disk size of nodes in GBs"
  type        = number
  default     = 50
}

variable "aks_dynamic_agents_vm_size" {
  description = "AKS 'dynamic' node pool - the default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_F16s_v2"
}

variable "aks_dynamic_enable_auto_scaling" {
  description = "AKS 'dynamic' node pool - enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "aks_dynamic_agents_node_min_count" {
  description = "AKS 'dynamic' node pool minimum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_dynamic_agents_node_count" {
  description = "The number of Agents that should exist in the 'dynamic' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes"
  type        = number
  default     = 1
}

variable "aks_dynamic_agents_max_pods" {
  description = "The maximum number of pods that can run on each agent in 'dynamic' node pool. Changing this forces a new resource to be created"
  type        = number
  default     = 100
}

variable "aks_base_agents_os_disk_size_gb" {
  description = "AKS 'base' node pool disk size of nodes in GBs"
  type        = number
  default     = 50
}

variable "aks_base_agents_vm_size" {
  description = "AKS 'base' node pool - the default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_F16s_v2"
}

variable "aks_base_enable_auto_scaling" {
  description = "AKS 'base' node pool - enable node pool autoscaling"
  type        = bool
  default     = false
}

variable "aks_base_agents_node_min_count" {
  description = "AKS 'base' node pool minimum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_base_agents_node_count" {
  description = "The number of Agents that should exist in the 'base' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes"
  type        = number
  default     = 1
}

variable "aks_base_agents_max_pods" {
  description = "The maximum number of pods that can run on each agent in 'base' node pool. Changing this forces a new resource to be created"
  type        = number
  default     = 100
}

variable "external_db" {
  description = "Database will be installed outside of AKS cluster"
  type        = bool
  default     = false
}

variable "postgresql_tier" {
  description = "Tier for PostgreSQL server sku : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers Possible values are: GeneralPurpose, Basic, MemoryOptimized"
  type        = string
  default     = "GeneralPurpose"
}

variable "postgresql_capacity" {
  description = "Capacity for PostgreSQL server sku - number of vCores : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers"
  type        = number
  default     = 4
}

variable "postgresql_force_ssl" {
  description = "Postgresql force usage of SSL"
  type        = bool
  default     = true
}

variable "postgresql_environment" {
  description = "Postgresql name of application's environnement"
  type        = string
  default     = "production"
}

variable "postgresql_version" {
  description = "Postgresql version. Valid values are 9.5, 9.6, 10, 10.0, and 11"
  type        = string
  default     = "11"
}

variable "postgresql_allowed_cidrs" {
  description = "Postgresql map of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state"
  type        = map(string)
  default     = { "1" = "10.0.0.0/24" }
}

variable "postgresql_storage_mb" {
  description = "Max storage allowed for a Postgresql server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  type        = number
  default     = 1048576
}

variable "postgresql_backup_retention_days" {
  description = "Bbackup retention days for the Postgresql server, supported values are between 7 and 35 days."
  type        = number
  default     = 10
}

variable "postgresql_geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant Postgresql server backups on/off. Not available for the Basic tier."
  type        = bool
  default     = true
}

variable "postgresql_auto_grow_enabled" {
  description = "Enable/Disable auto-growing of the Postgresql storage."
  type        = bool
  default     = false
}

variable "postgresql_configurations" {
  description = "PostgreSQL configurations to enable"
  type        = map(string)
  default     = {}
}

variable "postgresql_databases_names" {
  description = "The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier."
  type        = list(string)
  default     = ["edge"]
}

variable "postgresql_databases_collation" {
  description = "Valid PostgreSQL collation : http://www.postgresql.cn/docs/9.4/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN"
  type        = map(string)
  default     = { edge = "en-US" }
}

variable "postgresql_databases_charset" {
  description = "Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE"
  type        = map(string)
  default     = { edge = "UTF8" }
}

variable "postgresql_enable_logs_to_storage" {
  description = "Boolean flag to specify whether the Postgresql logs should be sent to the Storage Account"
  type        = bool
  default     = false
}

variable "postgresql_enable_logs_to_log_analytics" {
  description = "Boolean flag to specify whether the Postgresql logs should be sent to Log Analytics"
  type        = bool
  default     = false
}

variable "postgresql_logs_storage_retention" {
  description = "Retention in days for Postgresql logs on Storage Account"
  type        = number
  default     = 30
}

variable "postgresql_logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = string
  default     = ""
}

variable "postgresql_logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = string
  default     = ""
}

variable "postgresql_administrator_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "edge"
}

variable "external_redis" {
  description = "Redis will be installed outside of AKS cluster"
  type        = bool
  default     = false
}

variable "redis_environment" {
  description = "Name of the Redis environnement"
  type        = string
  default     = "production"
}

variable "redis_allow_non_ssl_connections" {
  description = "Activate non SSL port (6779) for Redis connection"
  type        = bool
  default     = true
}

variable "redis_sku_name" {
  description = "Redis Cache Sku name. Can be Basic, Standard or Premium"
  type        = string
  default     = "Premium"
}

variable "redis_capacity" {
  description = "Redis size: (Basic/Standard: 1,2,3,4,5,6) (Premium: 1,2,3,4)  https://docs.microsoft.com/fr-fr/azure/redis-cache/cache-how-to-premium-clustering"
  type        = number
  default     = 2
}

variable "redis_authorized_cidrs" {
  description = "Redis map of authorized cidrs"
  type        = map(string)
  default     = { ip1 = "10.0.0.0/16" }
}

variable "default_tags" {
  description = "Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable"
  default = {
    Terraform = "true"
  }
}

variable "tags" {
  description = "Any tags the user wishes to add to all resources of the edge"
  type        = map(string)
  default     = {}
}

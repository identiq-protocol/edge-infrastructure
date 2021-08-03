variable "external_store" { default = false }
variable "base_agents_size" {}
variable "base_agents_count" {}
variable "dynamic_agents_size" {}
variable "dynamic_agents_count" {}
variable "region" {}
variable "address_space" { default = "10.0.0.0/16" }
variable "resource_group" { default = "identiq-edge" }
variable "aks_prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
  default     = "identiq"
}

variable "aks_cluster_name" {
  description = "(Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'aks_prefix' var (The 'aks_prefix' var will still be applied to the dns_prefix if it is set)"
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

variable "aks_os_disk_size_gb" {
  description = "AKS disk size of nodes in GBs"
  type        = number
  default     = 50
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

variable "aks_default_agent_size" {
  description = "AKS 'default' node pool - the default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_A2_v2"
}


variable "aks_default_agents_min_count" {
  description = "Minimum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_default_agents_max_count" {
  description = "Maximum number of nodes in 'default' node pool"
  type        = number
  default     = 1
}

variable "aks_default_agents_count" {
  description = "The number of Agents that should exist in the 'default' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes"
  type        = number
  default     = 1
}

variable "aks_default_agents_max_pods" { 
description = "(Optional) The maximum number of pods that can run on each agent in 'default' node pool. Changing this forces a new resource to be created"
type = number
default = 100 
}

variable "network_policy" { default = "azure" }
variable "net_profile_dns_service_ip" { default = "10.30.0.10" }
variable "net_profile_docker_bridge_cidr" { default = "170.10.0.1/16" }
variable "net_profile_service_cidr" { default = "10.30.0.0/24" }
variable "aks_cache_vm_size" {
  description = "AKS cache node pool vm size"
  type        = string
  default     = "Standard_B8ms"
}
variable "aks_cache_node_count" {
  description = "AKS cache node pool initial number of nodes"
  type        = number
  default     = 1
}
variable "mysql_administrator_login" { default = "edge" }

locals {
  subnet_prefixes = [cidrsubnet(var.address_space, 4, 1), cidrsubnet(var.address_space, 4, 2), cidrsubnet(var.address_space, 4, 3)]
}

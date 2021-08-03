variable "base_agents_size" {}
variable "base_agents_count" {}
variable "dynamic_agents_size" {}
variable "dynamic_agents_count" {}
variable "region" {}
variable "address_space" { default = "10.0.0.0/16" }
variable "resource_group" { default = "identiq-edge" }
variable "cluster_prefix" { default = "identiq" }
variable "cluster_name" { default = "edge" }
variable "kubernetes_version" { default = "1.18.19" }
variable "external_store" { default = false }
variable "enable_role_based_access_control" { default = true }
variable "rbac_aad_managed" { default = true }
variable "private_cluster_enabled" { default = false }
variable "enable_log_analytics_workspace" { default = false }
variable "os_disk_size_gb" { default = 50 }
variable "network_plugin" { default = "azure" }
variable "sku_tier" { default = "Paid" }
variable "agents_pool_name" { default = "node" }
variable "network_policy" { default = "azure" }
variable "net_profile_dns_service_ip" { default = "10.30.0.10" }
variable "net_profile_docker_bridge_cidr" { default = "170.10.0.1/16" }
variable "net_profile_service_cidr" { default = "10.30.0.0/24" }
variable "agents_max_pods" { default = 100 }
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

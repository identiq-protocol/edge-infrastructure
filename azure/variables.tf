variable "agents_size" {}
variable "agents_count" {}
variable "region" {}
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
variable "cache_agent_size" { default = "Standard_B8ms" }
variable "mysql_administrator_login" { default = "edge" }

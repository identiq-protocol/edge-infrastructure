variable "agents_size" {}
variable "agents_count" {}
variable "region" {}
variable "resource_group" { default = "identiq-edge" }
variable "cluster_prefix" { default = "identiq" }
variable "cluster_name" { default = "edge" }
variable "kubernetes_version" { default = "1.18.19" }
variable "external_store" { default = false }

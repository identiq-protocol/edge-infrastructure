data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "cidrsubnet" {
  default = "10.0.0.0/16"
}

variable "instance_count" {
  default = "3"
}
variable "instance_type" {
  default = "c5n.4xlarge"
}

variable "cluster_name" {
  default = "edge-cluster"
}

variable "map_roles" {
  default = []
}

variable "map_users" {
  default = []
}

variable "additional_policies" {
  default = []
}

variable "db_instance_count" {default = 1}

variable "cache_instance_type" {default = "r5.2xlarge"}
variable "cache_instance_count" {default = 1}

variable "dynamic_instance_type" {default = "c5.4xlarge"}
variable "dynamic_instance_count" {default = 4}
variable "db_instance_type" {default = "m5.large"}
variable "base_instance_type" {default = "c5.2xlarge"}
variable "base_instance_count" {default = 1}


variable "external_store" { default = false }
variable "store_name" { default = "edge" }

variable "tags" {
  default = {
    Owner = "Identiq"
    Application = "IdentiqEdge"
  }
}

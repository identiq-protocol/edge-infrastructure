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
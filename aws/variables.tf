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

variable "additional_policies" {
  default = [""]
}

variable "internal_domain_name" {
  default = "NOT_SET"
}
variable "external_domain_name" {
  default = "NOT_SET"
}
variable "edge_eks_subnets" {
  default = concat(module.vpc.private_subnets, module.vpc.public_subnets)
}

variable "edge_asg_subnet" {
  default = [module.vpc.private_subnets[0]]
}
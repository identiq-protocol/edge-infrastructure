provider "aws" {
  region = var.region
}

variable "service_name" {}
variable "vpc_id" {}
data aws_vpc "current" {
  id = var.vpc_id
}
variable "region" {
  default = "us-east-1"
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.current.id
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

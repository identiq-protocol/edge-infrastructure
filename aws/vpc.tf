module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  name    = "identiq-vpc"
  cidr    = var.cidrsubnet

  azs                  = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  private_subnets      = [cidrsubnet(var.cidrsubnet, 4, 1), cidrsubnet(var.cidrsubnet, 4, 2), cidrsubnet(var.cidrsubnet, 4, 3)]
  public_subnets       = [cidrsubnet(var.cidrsubnet, 4, 4), cidrsubnet(var.cidrsubnet, 4, 5), cidrsubnet(var.cidrsubnet, 4, 6)]
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Terraform                                   = "true"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

  }

  public_subnet_tags = {
    Terraform                                   = "true"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"           = "1"
  }
  private_subnet_tags = {
    Terraform                                   = "true"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

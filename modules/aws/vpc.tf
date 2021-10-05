module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "3.2.0"
  name                 = var.vpc_name
  cidr                 = var.vpc_cidrsubnet
  count                = var.external_vpc ? 0 : 1
  azs                  = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  private_subnets      = [cidrsubnet(var.vpc_cidrsubnet, 4, 1), cidrsubnet(var.vpc_cidrsubnet, 4, 2), cidrsubnet(var.vpc_cidrsubnet, 4, 3)]
  public_subnets       = [cidrsubnet(var.vpc_cidrsubnet, 4, 4), cidrsubnet(var.vpc_cidrsubnet, 4, 5), cidrsubnet(var.vpc_cidrsubnet, 4, 6)]
  enable_nat_gateway   = var.vpc_enable_nat_gateway
  enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  tags                = merge(var.tags, var.default_tags, { "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" })
  public_subnet_tags  = merge(var.tags, var.default_tags, { "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared", "kubernetes.io/role/elb" = "1" })
  private_subnet_tags = merge(var.tags, var.default_tags, { "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared", "kubernetes.io/role/internal-elb" = "1" })
}

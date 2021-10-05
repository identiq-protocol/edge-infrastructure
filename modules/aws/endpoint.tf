resource "aws_vpc_endpoint" "ep" {
  count              = var.vpc_endpoint_service_name != "" ? 1 : 0
  service_name       = var.vpc_endpoint_service_name
  vpc_id             = local.ep_vpc_id
  vpc_endpoint_type  = var.vpc_endpoint_type
  security_group_ids = [module.eks.worker_security_group_id]
  subnet_ids         = local.ep_private_subnets
  tags               = var.tags
}

locals {
  ep_vpc_id          = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
  ep_private_subnets = var.external_vpc ? var.eks_private_subnets : module.vpc[0].private_subnets
}

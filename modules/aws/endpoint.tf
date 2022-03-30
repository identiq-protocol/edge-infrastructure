resource "aws_vpc_endpoint" "ep" {
  count              = contains(keys(local.vpc_endpoint_service_name), var.region) ? 1 : 0
  service_name       = local.vpc_endpoint_service_name[var.region]
  vpc_id             = local.ep_vpc_id
  vpc_endpoint_type  = var.vpc_endpoint_type
  security_group_ids = [module.eks.worker_security_group_id]
  subnet_ids         = local.ep_private_subnets
  tags               = var.tags
}

locals {
  ep_vpc_id          = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
  ep_private_subnets = var.external_vpc ? var.eks_private_subnets : module.vpc[0].private_subnets
  vpc_endpoint_service_name = {
    "us-east-1" : "com.amazonaws.vpce.us-east-1.vpce-svc-0964eccd96e1f130c"
    "us-west-2" : "com.amazonaws.vpce.us-west-2.vpce-svc-00bca346ea4e4a49a"
  }
}

resource "aws_vpc_endpoint" "ep" {
  count              = contains(keys(local.vpc_endpoint_service_name_map), var.region) || var.vpc_custom_service_name != "" ? 1 : 0
  service_name       = local.vpc_endpoint_service_name
  vpc_id             = local.ep_vpc_id
  vpc_endpoint_type  = var.vpc_endpoint_type
  security_group_ids = [module.eks.cluster_primary_security_group_id]
  subnet_ids         = local.ep_private_subnets
  tags               = local.tags
}

locals {
  ep_vpc_id                 = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
  ep_private_subnets        = var.external_vpc ? var.eks_private_subnets : module.vpc[0].private_subnets
  vpc_endpoint_service_name = var.vpc_custom_service_name != "" ? var.vpc_custom_service_name : local.vpc_endpoint_service_name_map[var.region]
  vpc_endpoint_service_name_map = {
    "us-east-1" : "com.amazonaws.vpce.us-east-1.vpce-svc-0964eccd96e1f130c"
    "us-west-2" : ""
    "eu-central-1" : "com.amazonaws.vpce.eu-central-1.vpce-svc-0ead3a40b72d7e586"
  }
}

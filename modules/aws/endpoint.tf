resource "aws_vpc_endpoint" "ep" {
  count              = var.vpc_endpoint_service_name != "" ? 1 : 0
  service_name       = var.vpc_endpoint_service_name
  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = var.vpc_endpoint_type
  security_group_ids = [module.eks.worker_security_group_id]
  subnet_ids         = module.vpc.private_subnets
}

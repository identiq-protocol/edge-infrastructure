resource "aws_vpc_endpoint_service" "ep" {
  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = [var.nlb_arn]
  allowed_principals         = var.allowed_principals
  tags                       = var.tags
}

provider "aws" {
  region = var.region
}

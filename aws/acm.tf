resource "aws_acm_certificate" "ext-cert" {
  count = var.external_domain_name != "NOT_SET" ? 1 : 0
  domain_name       = var.external_domain_name
  validation_method = "DNS"
  tags = {
    Environment = "Prod"
    ClusterName = var.cluster_name
  }
}

resource "aws_acm_certificate" "int-cert" {
  count = var.internal_domain_name != "NOT_SET" ? 1 : 0
  domain_name       = var.internal_domain_name
  validation_method = "DNS"
  tags = {
    Environment = "Prod"
    ClusterName = var.cluster_name
  }
}
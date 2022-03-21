output "connect" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.eks_cluster_name}"
}

output "nat_ips" {
  value = var.external_vpc ? [] : module.vpc[0].nat_public_ips
}

output "vpc_id" {
  value = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
}

output "endpoint_address" {
  value = var.vpc_endpoint_service_name != "" ? aws_vpc_endpoint.ep[0].dns_entry[0]["dns_name"] : ""
}

output "pinki_ingress_id" {
  value = aws_security_group.pinki_ingress.id
}
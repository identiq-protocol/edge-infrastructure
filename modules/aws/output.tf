output "connect" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.eks_cluster_name}"
}

output "nat_ips" {
  value = var.external_vpc ? [] : module.vpc.nat_public_ips
}

output "vpc_id" {
  value = var.external_vpc ? var.eks_vpc_id : module.vpc.vpc_id
}

output "endpoint_address" {
  value = var.vpc_endpoint_service_name != "" ? aws_vpc_endpoint.ep[0].dns_entry[0]["dns_name"] : ""
}

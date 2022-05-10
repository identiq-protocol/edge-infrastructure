output "connect" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.eks_cluster_name}"
}

output "nat_ips" {
  value = var.external_vpc ? [] : module.vpc[0].nat_public_ips
}

output "vpc_id" {
  value = local.identiqVersion["vpcId"]
}

output "endpoint_address" {
  value = local.identiqVersion["vpcEndpointAddress"]
}

output "pinky_ingress_id" {
  value = aws_security_group.pinky_ingress.id
}

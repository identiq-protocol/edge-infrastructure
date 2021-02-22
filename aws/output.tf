output connect {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}

output nat_ips {
  value = module.vpc.nat_public_ips
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
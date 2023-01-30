output "gke_connect" {
  value       = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.region} --project ${var.project_id}"
  description = "command to generate gke kubeconfig "
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "nat_ip" {
  value = module.vpc.nat_ip
}

output "cloud_sql_service_accounts" {
  value = values(module.cloud-sql-workload-identity).*.gcp_service_account_email
}

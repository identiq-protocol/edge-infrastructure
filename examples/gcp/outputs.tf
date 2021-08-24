output "connect" {
  value       = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.region} --project ${var.project_id}"
  description = "command to generate gke kubeconfig "
}

output "network_name" {
  value       = module.edge-gcp.network_name
  description = "The name of the VPC being created"
}

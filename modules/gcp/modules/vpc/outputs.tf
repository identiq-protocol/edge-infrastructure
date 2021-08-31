output "network_name" {
  value       = google_compute_network.vpc_network.name
  description = "The name of the VPC being created"
}
output "subnetwork_name" {
  value = google_compute_subnetwork.private-subnetwork.name
}
output "network_id" {
  value = google_compute_network.vpc_network.id
}
output "nat_ip" {
  value = google_compute_address.external_nat_address.address
}

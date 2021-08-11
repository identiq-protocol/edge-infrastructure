resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks

}
resource "google_compute_subnetwork" "private-subnetwork" {
  name = "${var.vpc_name}-subnetwork-private"
  ip_cidr_range = var.subnetwork_cidr_range
  region = var.region
  network = google_compute_network.vpc_network.name

}

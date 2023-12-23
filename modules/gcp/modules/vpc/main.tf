resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks

}
resource "google_compute_subnetwork" "private-subnetwork" {
  name          = "${var.vpc_name}-subnetwork-private"
  ip_cidr_range = var.subnetwork_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.name

}
resource "google_compute_firewall" "default" {
  count   = var.enable_ssh_firewall_rule ? 1 : 0
  name    = "allow-ssh-${google_compute_network.vpc_network.name}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "external_nat_address" {
  name         = var.vpc_external_nat_address_name != "" ? var.vpc_external_nat_address_name : "${var.vpc_name}-nat-ip"
  address_type = "EXTERNAL"
  region       = var.region
}
resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.vpc_nat_router_name
  network = google_compute_network.vpc_network.name
  region  = var.region
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "2.2.2"
  project_id                         = var.project_id
  region                             = var.region
  router                             = google_compute_router.router.name
  name                               = "nat-config"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ips                            = [google_compute_address.external_nat_address.name]
}

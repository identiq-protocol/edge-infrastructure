variable "project_id" {
  description = "The project ID to host the vpc in"
}
variable "region" {
  description = "The region to host the subnet in"
}
variable "vpc_name" {
  description = "The name of the vpc"
  default = "identiq-vpc"
}
variable "subnetwork_cidr_range" {
  description = "The ip range for the subnetwork"
  default = "10.2.0.0/16"
}
variable "auto_create_subnetworks" {
  description = "vpc will auto create subnetworks for each region"
  default = false
}
variable "enable_ssh_firewall_rule" {
  description = "create firewall rule to enable ssh access"
  default = false
}

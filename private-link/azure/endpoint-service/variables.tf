variable "resource_group" { default = "identiq-edge" }
variable "lb_name" { default = "kubernetes-internal" }
variable "virtual_network_name" { default = "acctvnet" }
variable "subnet_name" { default = "subnet1" }
variable "private_link_service_name" { default = "identiq-privatelink-service" }
variable "aks_name" { default = "edge" }
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = var.virtual_network_name
}

data "azurerm_lb" "lb" {
  resource_group_name = "mc_${data.azurerm_resource_group.rg.name}_${var.aks_name}_${data.azurerm_resource_group.rg.location}"
  name                = var.lb_name
}

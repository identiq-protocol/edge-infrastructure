variable "resource_group" { default = "identiq-edge" }
variable "lb_name" { default = "kubernetes-internal" }
variable "virtual_network_name" { default = "acctvnet" }
variable "subnet_name" { default = "subnet1" }

data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = var.virtual_network_name
}

data "azurerm_lb" "lb" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.lb_name
}

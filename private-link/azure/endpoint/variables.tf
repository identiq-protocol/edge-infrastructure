variable "resource_group" { default = "identiq-edge" }
variable "private_connection_resource_alias" {}
variable "subnet_name" { default = "subnet1" }
variable "virtual_network_name" { default = "acctvnet" }
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = var.virtual_network_name
}

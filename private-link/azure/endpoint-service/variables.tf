variable "resource_group" { default = "identiq-edge" }
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_subnet" subnet {
  name = "subnet1"
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = "acctvnet"
}

data "azurerm_lb" lb {
  resource_group_name = "mc_${data.azurerm_resource_group.rg.name}_edge_${data.azurerm_resource_group.rg.location}"
  name = "kubernetes-internal"
}

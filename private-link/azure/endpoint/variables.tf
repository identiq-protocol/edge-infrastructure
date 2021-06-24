variable "resource_group" { default = "edges" }
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_subnet" subnet {
  name = "aks-subnet"
  resource_group_name = "MC_${data.azurerm_resource_group.rg.name}_mindy-aks_${data.azurerm_resource_group.rg.location}"
  virtual_network_name = "aks-vnet-32535372"
}

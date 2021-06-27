provider "azurerm" {
  features {}
}

resource "azurerm_private_endpoint" "example" {
  name                = var.private_endpoint_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id
  private_service_connection {
    name                              = "PrivateEndpoint"
    request_message                   = var.private_endpoint_request_message
    is_manual_connection              = true
    private_connection_resource_alias = var.private_connection_resource_alias
  }
}

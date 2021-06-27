provider "azurerm" {
  features {}
}

resource "azurerm_private_endpoint" "example" {
  name                = "identiq-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id
  private_service_connection {
    name                              = "PrivateEndpoint"
    request_message                   = "Approve Request"
    is_manual_connection              = true
    private_connection_resource_alias = var.private_connection_resource_alias
  }
}


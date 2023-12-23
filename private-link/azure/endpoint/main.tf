provider "azurerm" {
  features {}
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = var.private_endpoint_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id
  private_service_connection {
    name                              = var.endpoint_private_service_connection_name
    request_message                   = var.private_endpoint_request_message
    is_manual_connection              = true
    private_connection_resource_alias = var.private_connection_resource_alias
  }
}

data "azurerm_private_endpoint_connection" "ip_address" {
  name                = var.private_endpoint_name
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on          = [azurerm_private_endpoint.endpoint]
}

output "ip_address" {
  value = data.azurerm_private_endpoint_connection.ip_address.private_service_connection[0].private_ip_address
}

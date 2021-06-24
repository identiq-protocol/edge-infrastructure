provider "azurerm" {
  features {}
}

resource "azurerm_private_endpoint" "example" {
  name                = "identiq-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id
  private_service_connection {
    name = "aaa"
    request_message = "approve me"
    is_manual_connection = true
    private_connection_resource_alias = "identiq-privatelink-service.b2233e05-12e2-43c1-82dc-8709338a7d55.eastus.azure.privatelinkservice"
  }

}



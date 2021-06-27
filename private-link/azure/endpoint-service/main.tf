provider "azurerm" {
  features {}
}

resource "azurerm_private_link_service" "service" {
  name                = var.private_link_service_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  nat_ip_configuration {
    name      = "primary"
    primary   = true
    subnet_id = data.azurerm_subnet.subnet.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    data.azurerm_lb.lb.frontend_ip_configuration.0.id,
  ]
}
output "service_name" {
  value = azurerm_private_link_service.service.alias
}


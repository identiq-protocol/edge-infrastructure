resource "azurerm_mysql_virtual_network_rule" "vnet_rules" {
  count = length(var.allowed_subnets)

  name = format(
    "%s-%s",
    element(split("/", var.allowed_subnets[count.index]), 8), # VNet name
    element(split("/", var.allowed_subnets[count.index]), 10) # Subnet name
  )
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  subnet_id           = var.allowed_subnets[count.index]
}

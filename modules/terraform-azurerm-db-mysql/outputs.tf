output "mysql_administrator_login" {
  value       = local.administrator_login
  description = "Administrator login for MySQL server"
}

output "mysql_databases_names" {
  value       = azurerm_mysql_database.mysql_db[*].name
  description = "List of databases names"
}

output "mysql_database_ids" {
  description = "The list of all database resource ids"
  value       = azurerm_mysql_database.mysql_db[*].id
}

output "mysql_firewall_rule_ids" {
  value       = azurerm_mysql_firewall_rule.firewall_rules[*].id
  description = "List of MySQL created rules"
}

output "mysql_fqdn" {
  value       = azurerm_mysql_server.mysql_server.fqdn
  description = "FQDN of the MySQL server"
}

output "mysql_server_id" {
  value       = azurerm_mysql_server.mysql_server.id
  description = "MySQL server ID"
}

output "mysql_server_name" {
  value       = azurerm_mysql_server.mysql_server.name
  description = "MySQL server name"
}

output "mysql_vnet_rule_ids" {
  value       = azurerm_mysql_virtual_network_rule.vnet_rules[*].id
  description = "The list of all vnet rule resource ids"
}

output "mysql_configuration_id" {
  value       = azurerm_mysql_configuration.mysql_config[*].id
  description = "The list of all configurations resource ids"
}

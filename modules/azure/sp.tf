resource "azuread_application" "app" {
  display_name = var.ad_application_dispaly_name
}

# Create Service Principal
resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
}

#resource "random_string" "password" {
#  length  = 32
#  special = true
#}

# Create Service Principal password
resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.id
}

resource "azurerm_role_assignment" "assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.app.id
}

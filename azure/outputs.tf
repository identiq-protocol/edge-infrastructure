output "connect" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${var.cluster_name}"
}

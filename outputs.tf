output "resource_group" {
  value = azurerm_resource_group.this
}

output "automation_account" {
  value = azurerm_automation_account.this
}

output "azuread_application" {
  value = var.enable_web_app ? azuread_application.this[0] : null
}

output "app_service" {
  value = var.enable_web_app ? azurerm_app_service.this[0] : null
}
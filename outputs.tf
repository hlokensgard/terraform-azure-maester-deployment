output "default_site_hostname" {
  value = var.enable_web_app ? azurerm_app_service.this[0].default_site_hostname : null
}
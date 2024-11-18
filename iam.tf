data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

resource "azuread_app_role_assignment" "this" {
  for_each            = toset(var.app_roles)
  app_role_id         = azuread_service_principal.msgraph.app_role_ids[each.key]
  principal_object_id = azurerm_automation_account.this.identity[0].principal_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}
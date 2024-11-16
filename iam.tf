resource "azurerm_role_assignment" "aa_blob_data_owner_storage_account" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "aa_contributor_storage_account" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}

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

resource "time_sleep" "wait_for_role_assignments" {
  depends_on = [
    azurerm_role_assignment.aa_contributor_storage_account,
    azurerm_role_assignment.aa_blob_data_owner_storage_account
  ]
  create_duration = "240s"
}

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

locals {
  directory_roles = {
    "Directory.Read.All" = {
      "id" = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
    },
    "DirectoryRecommendations.Read.All" = {
      "id" = "ae73097b-cb2a-4447-b064-5d80f6093921"
    }
    "IdentityRiskEvent.Read.All" = {
      "id" = "6e472fd1-ad78-48da-a0f0-97ab2c6b769e"
    },
    "Policy.Read.All" = {
      "id" = "246dd0d5-5bd0-4def-940b-0421030a5b68"
    },
    "Policy.Read.ConditionalAccess" = {
      "id" = "37730810-e9ba-4e46-b07e-8ca78d182097"
    },
    "PrivilegedAccess.Read.AzureAD" = {
      "id" = "4cdc2547-9148-4295-8d11-be0db1391d6b"
    },
    "Reports.Read.All" = {
      "id" = "230c1aed-a721-4c5d-9cb4-a90514e508ef"
    },
    "RoleEligibilitySchedule.Read.Directory" = {
      "id" = "ff278e11-4a33-4d0c-83d2-d01dc58929a5"
    },
    "RoleManagement.Read.Directory" = {
      "id" = "483bed4a-2ad3-4361-a73b-c83ccdbdc53c"
    },
    "RoleManagement.Read.All" = {
      "id" = "c7fbd983-d9aa-4fa7-84b8-17382c103bc4"
    },
    "SharePointTenantSettings.Read.All" = {
      "id" = "83d4163d-a2d8-4d3b-9695-4ae3ca98f888"
    },
    "UserAuthenticationMethod.Read.All" = {
      "id" = "38d9df27-64da-44fd-b7c5-a6fbac20248f"
    },
    "Mail.Send" = {
      "id" = "b633e1c5-b582-4048-a93e-9f11b44c7e96"
    }
  }
}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

resource "azuread_app_role_assignment" "this" {
  for_each            = local.directory_roles
  app_role_id         = azuread_service_principal.msgraph.app_role_ids[each.key]
  principal_object_id = azurerm_automation_account.this.identity[0].principal_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "time_sleep" "wait_for_role_assignments" {
  depends_on = [
    azurerm_role_assignment.aa_contributor_storage_account,
    azurerm_role_assignment.aa_blob_data_owner_storage_account
  ]
  create_duration = "180s"
}

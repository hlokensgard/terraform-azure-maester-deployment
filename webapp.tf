resource "azurerm_app_service_plan" "this" {
  count               = var.enable_web_app ? 1 : 0
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku {
    tier = var.app_service_plan["tier"]
    size = var.app_service_plan["size"]
  }
}

resource "random_pet" "app_service_suffix" {
  separator = "-"
}
locals {
  # Need a global unique name for the app service
  app_service_name = "maester-${random_pet.app_service_suffix.id}"
}

resource "azurerm_app_service" "this" {
  count               = var.enable_web_app ? 1 : 0
  name                = local.app_service_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = azurerm_app_service_plan.this[0].id
  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled                       = true
    default_provider              = "AzureActiveDirectory"
    token_store_enabled           = true
    issuer                        = "https://sts.windows.net/${data.azurerm_client_config.this.tenant_id}/v2.0"
    unauthenticated_client_action = "RedirectToLoginPage"
    runtime_version               = "~1"

    active_directory {
      client_id = azuread_application.this[0].client_id
    }
  }
}

resource "azurerm_role_assignment" "this" {
  count                = var.enable_web_app ? 1 : 0
  scope                = azurerm_app_service.this[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}

resource "azuread_application" "this" {
  count            = var.enable_web_app ? 1 : 0
  display_name     = "app-maester"
  sign_in_audience = "AzureADMyOrg"
  web {
    redirect_uris = ["https://${local.app_service_name}.azurewebsites.net/.auth/login/aad/callback"]
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

locals {
  automation_account_variables = {
    "EmailAddress" = {
      "description" = "The email address of the user that will receive the reports"
      "value"       = var.email_address
    }
    "ResourceGroupName" = {
      "description" = "The name of the resource group"
      "value"       = azurerm_resource_group.this.name
    }
    "AppServiceName" = {
      "description" = "The name of the App Service"
      "value"       = var.enable_web_app ? azurerm_app_service.this[0].name : null
    }
    "EnableWebApp" = {
      "description" = "Enable the Web App"
      "value"       = var.enable_web_app
    }
  }
}

resource "azurerm_automation_variable_string" "this" {
  for_each                = local.automation_account_variables
  name                    = each.key
  resource_group_name     = azurerm_automation_account.this.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  description             = each.value.description
  encrypted               = false
  value                   = each.value.value
}

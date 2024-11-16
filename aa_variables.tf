locals {
  automation_account_variables = {
    "EmailAddress" = {
      "description" = "The email address of the user that will receive the reports"
      "value"       = var.email_address
    }
    "StorageAccountName" = {
      "description" = "The name of the storage account"
      "value"       = azurerm_storage_account.this.name
    }
    "ContainerName" = {
      "description" = "The name of the storage account container"
      "value"       = azurerm_storage_container.this.name
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
    "EnableTeamsIntegration" = {
      "description" = "Enable the Teams integration"
      "value"       = var.enable_teams_integration
    }
    "TeamId" = {
      "description" = "The id of the Microsoft Team that will be used for receiving the reports"
      "value"       = var.team_id
    }
    "ChannelId" = {
      "description" = "The id of the channel in the Microsoft Team that will be used for receiving the reports"
      "value"       = var.channel_id
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

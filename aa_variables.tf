locals {
  automation_account_variables = {
    "EmailAddress" = {
      "description" = "The email address of the user that will receive the reports"
      "value"       = var.email_address
    }
  }
}

resource "azurerm_automation_variable_string" "this" {
  for_each                = local.automation_account_variables
  name                    = each.key
  resource_group_name     = azurerm_automation_account.this.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  description             = each.value.description
  encrypted               = true
  value                   = each.value.value
}

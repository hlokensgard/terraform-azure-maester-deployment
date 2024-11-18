resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_automation_account" "this" {
  name                = var.automation_account_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku_name = "Basic"
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_automation_powershell72_module" "this" {
  for_each              = local.aa_modules
  name                  = each.key
  automation_account_id = azurerm_automation_account.this.id
  module_link {
    uri = each.value.uri
  }
}

resource "azurerm_automation_runbook" "this" {
  name                    = "maester"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Maester runbook"
  runbook_type            = "PowerShell72"
  content                 = data.local_file.powershell_runbook.content
}

resource "azurerm_automation_schedule" "this" {
  lifecycle {
    ignore_changes = [
      start_time
    ]
  }
  name                    = "scheduleMaester"
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = title(var.run_schedule)
  interval                = 1
  start_time              = timeadd(timestamp(), "1h")
  expiry_time             = "9999-12-31T23:59:59.9999999+00:00"
}

resource "azurerm_automation_job_schedule" "this" {
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  runbook_name            = azurerm_automation_runbook.this.name
  schedule_name           = azurerm_automation_schedule.this.name
}
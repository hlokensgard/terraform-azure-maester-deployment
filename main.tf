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

# Create a random integer for the storage account names
resource "random_integer" "storage_account_suffix" {
  min = "10000"
  max = "99999"
}

resource "azurerm_storage_account" "this" {
  lifecycle {
    ignore_changes = [
      name
    ]
  }
  name                            = "${var.storage_account_name}${random_integer.storage_account_suffix.result}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  public_network_access_enabled   = true
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = true
  tags                            = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = var.storage_account_blob_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "this" {
  name                   = "maester"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source                 = var.file_path
  content_md5            = filemd5(var.file_path)
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

  publish_content_link {
    uri = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.this.name}/${azurerm_storage_blob.this.name}${data.azurerm_storage_account_blob_container_sas.this.sas}"
  }
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
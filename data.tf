data "azurerm_client_config" "this" {}

# Uploads the script as a runbook to the automation account
data "local_file" "powershell_runbook" {
  filename = var.file_path
}

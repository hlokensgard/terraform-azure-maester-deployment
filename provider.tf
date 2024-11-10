provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
  skip_provider_registration = true
}
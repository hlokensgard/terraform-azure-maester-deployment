module "maester_deployment_simple" {
  source  = "hlokensgard/maester-deployment/azure"
  version = "~>2.0"
}

# Don't deploy web app
module "maester_deployment_no_web_app" {
  source         = "hlokensgard/maester-deployment/azure"
  version        = "~>2.0"
  enable_web_app = false
}

# Custom configuration
module "maester_deployment_custom" {
  source                    = "hlokensgard/maester-deployment/azure"
  version                   = "~>2.0"
  resource_group_name       = "my-rg"
  location                  = "East US"
  storage_account_name      = "mystorageaccount"
  storage_account_blob_name = "myblob"
  automation_account_name   = "my-aa"
  email_address             = "myEmail"
  app_roles                 = ["Directory.Read.All"]
  file_path                 = "path/to/file"
  run_schedule              = "Week"
  enable_web_app            = true
  app_service_name          = "my-app-service"
  app_service_plan          = "my-app-service-plan"
  tags = {
    environment = "test"
  }
}
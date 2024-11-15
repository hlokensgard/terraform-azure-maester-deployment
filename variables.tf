variable "resource_group_name" {
  description = "The name of the resource group that will contain the resources"
  type        = string
  default     = "rg-maester"
}

variable "location" {
  description = "The location/region where the resources will be created"
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    environment = "dev"
  }
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "stgmaester"
}

variable "storage_account_blob_name" {
  description = "The name of the blob container in the storage account. The name needs to be shorter then 19 characters, since a random integer is added to the storage account name."
  type        = string
  default     = "maester"
}

variable "automation_account_name" {
  description = "The name of the Automation account"
  type        = string
  default     = "aa-maester"
}

variable "email_address" {
  description = "The email address of the user that will receive the reports"
  type        = string
  default     = null
}

variable "app_roles" {
  description = "A map of app roles to assign to the managed identity for the automation account. This have as default every role you need to run Maester. But you need to give admin consent after assigning the roles."
  type        = list(string)
  default = [
    "Directory.Read.All",
    "DirectoryRecommendations.Read.All",
    "IdentityRiskEvent.Read.All",
    "Policy.Read.All",
    "Policy.Read.ConditionalAccess",
    "PrivilegedAccess.Read.AzureAD",
    "Reports.Read.All",
    "RoleEligibilitySchedule.Read.Directory",
    "RoleManagement.Read.Directory",
    "RoleManagement.Read.All",
    "SharePointTenantSettings.Read.All",
    "UserAuthenticationMethod.Read.All",
    "Mail.Send"
  ]
}

variable "file_path" {
  description = "The path to the file that will be uploaded to the storage account and used as the runbook. This should contain the Maester script."
  type        = string
  default     = "runbooks/maester.ps1"
}

variable "run_schedule" {
  description = "The schedule for the runbook. Valied inputs are day, week or month. The runbook will then once every day, week or month."
  type        = string
  validation {
    condition     = contains(["Day", "Week", "Month", "day", "week", "month"], var.run_schedule)
    error_message = "The run_schedule variable must be one of: Day, Week, Month."
  }
  default = "Month"
}

variable "owner_of_entra_id_group" {
  description = "The object id of the user that will be the owner of the Entra ID group that gives access to the web app."
  type        = string
  default     = null
}

variable "enable_web_app" {
  description = "Enable the creation of the web app"
  type        = bool
  default     = true
}

variable "app_service_name" {
  description = "The name of the App Service"
  type        = string
  default     = "app-maester"
}

variable "app_service_plan" {
  description = "The configuration of the App Service Plan"
  type        = map(string)
  default = {
    tier = "Basic"
    size = "B1"
  }
}
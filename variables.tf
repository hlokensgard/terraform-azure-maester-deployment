variable "resource_group_name" {
  description = "The name of the resource group"
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
  description = "The name of the blob container in the storage account"
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
  default     = ""
}

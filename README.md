# Terraform Module for Deploying Maester
This Terraform module simplifies the deployment of the **Maester** tool, enabling you to quickly set it up in your Azure tenant. The primary goal is to provide valuable insights into the security of your Azure environment with minimal mandatory configuration. You can customize key settings as needed. For more information about Maester, [visit the official website](https://maester.dev/).

## Prerequisites
To use this module, you need to provide the `maester.ps1` script as input. You can find examples of how to run the script and the available functions on Maester's website. [There is also an example here](runbooks/maester.ps1)

### Permissions
Ensure you have access to a privileged role that can grant **Admin Consent** (e.g., Global Administrator) for the managed identity running the runbook. [For more details on granting Admin Consent, refer to the Microsoft documentation](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent?pivots=portal).

## Solution Overview
This solution uses an **Azure Automation Account** to execute a runbook using the managed identity of the automation account. This setup allows you to evaluate your tenant based on the tests defined in your PowerShell script. Simply provide your script as input to the module to get started.

### Web app 
The module provides the option to set up an web application to display the report from `Maester`. The web app is configured to only allow members of my organization access. 

# Possible further improvements 
- Restrict access to the web application
- Implement other deployment options that are supported by `Maester`. Such as:
   - Azure DevOps integration
   - Slack integration
   - GitHub integration
- Option for storing the report in a dedicated storage account


# Example of use 
[Examples can be found here](examples/main.tf)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~>3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_app_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service) | resource |
| [azurerm_app_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) | resource |
| [azurerm_automation_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_automation_job_schedule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | resource |
| [azurerm_automation_powershell72_module.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_powershell72_module) | resource |
| [azurerm_automation_runbook.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_schedule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |
| [azurerm_automation_variable_string.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_string) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_pet.app_service_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [local_file.powershell_runbook](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_roles"></a> [app\_roles](#input\_app\_roles) | A map of app roles to assign to the managed identity for the automation account. This have as default every role you need to run Maester. But you need to give admin consent after assigning the roles. | `list(string)` | <pre>[<br/>  "Directory.Read.All",<br/>  "DirectoryRecommendations.Read.All",<br/>  "IdentityRiskEvent.Read.All",<br/>  "Policy.Read.All",<br/>  "Policy.Read.ConditionalAccess",<br/>  "PrivilegedAccess.Read.AzureAD",<br/>  "Reports.Read.All",<br/>  "RoleEligibilitySchedule.Read.Directory",<br/>  "RoleManagement.Read.Directory",<br/>  "RoleManagement.Read.All",<br/>  "SharePointTenantSettings.Read.All",<br/>  "UserAuthenticationMethod.Read.All",<br/>  "Mail.Send"<br/>]</pre> | no |
| <a name="input_app_service_name"></a> [app\_service\_name](#input\_app\_service\_name) | The name of the App Service | `string` | `"app-maester"` | no |
| <a name="input_app_service_plan"></a> [app\_service\_plan](#input\_app\_service\_plan) | The configuration of the App Service Plan | `map(string)` | <pre>{<br/>  "size": "B1",<br/>  "tier": "Basic"<br/>}</pre> | no |
| <a name="input_app_service_plan_name"></a> [app\_service\_plan\_name](#input\_app\_service\_plan\_name) | The name of the App Service Plan | `string` | `"maester-app-service-plan"` | no |
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | The name of the Automation account | `string` | `"aa-maester"` | no |
| <a name="input_email_address"></a> [email\_address](#input\_email\_address) | The email address of the user that will receive the reports | `string` | `null` | no |
| <a name="input_enable_web_app"></a> [enable\_web\_app](#input\_enable\_web\_app) | Enable the creation of the web app | `bool` | `true` | no |
| <a name="input_file_path"></a> [file\_path](#input\_file\_path) | The path to the file that will be uploaded to the storage account and used as the runbook. This should contain the Maester script. | `string` | `"runbooks/maester.ps1"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group that will contain the resources | `string` | `"rg-maester"` | no |
| <a name="input_run_schedule"></a> [run\_schedule](#input\_run\_schedule) | The schedule for the runbook. Valied inputs are day, week or month. The runbook will then once every day, week or month. | `string` | `"Month"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | <pre>{<br/>  "environment": "dev"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service"></a> [app\_service](#output\_app\_service) | n/a |
| <a name="output_automation_account"></a> [automation\_account](#output\_automation\_account) | n/a |
| <a name="output_azuread_application"></a> [azuread\_application](#output\_azuread\_application) | n/a |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | n/a |
<!-- END_TF_DOCS -->
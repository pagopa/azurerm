# app service

This module allow the creation of an let's encrypt credentials

## Architecture

TBD

## Configurations

### Mandatory configurations

## How to use it

```ts
module "letsencrypt" {
  source =
    "git::https://github.com/pagopa/azuredevops-tf-modules.git//letsencrypt_credential?ref=v2.14.0";

  prefix = "project";
  env = "p";
  key_vault_name = "project-p-kv";
  subscription_name = "DEV-PROJECT";
}
```

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version              |
| ------------------------------------------------------------------------ | -------------------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.1.0             |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | >= 2.80.0, <= 2.99.0 |

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | 2.99.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                                                              | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_app_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service)                                                                                                           | resource |
| [azurerm_app_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan)                                                                                                 | resource |
| [azurerm_app_service_virtual_network_swift_connection.app_service_virtual_network_swift_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) | resource |

## Inputs

| Name                                                                                                                                 | Description                                                                                                                                                                                                                                       | Type           | Default        | Required |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------------- | :------: |
| <a name="input_allowed_ips"></a> [allowed_ips](#input_allowed_ips)                                                                   | (Optional) List of ips allowed to call the appserver endpoint.                                                                                                                                                                                    | `list(string)` | `[]`           |    no    |
| <a name="input_allowed_subnets"></a> [allowed_subnets](#input_allowed_subnets)                                                       | (Optional) List of subnet allowed to call the appserver endpoint.                                                                                                                                                                                 | `list(string)` | `[]`           |    no    |
| <a name="input_always_on"></a> [always_on](#input_always_on)                                                                         | (Optional) Should the app be loaded at all times? Defaults to false.                                                                                                                                                                              | `bool`         | `false`        |    no    |
| <a name="input_app_command_line"></a> [app_command_line](#input_app_command_line)                                                    | (Optional) App command line to launch, e.g. /sbin/myserver -b 0.0.0.0.                                                                                                                                                                            | `string`       | `null`         |    no    |
| <a name="input_app_settings"></a> [app_settings](#input_app_settings)                                                                | n/a                                                                                                                                                                                                                                               | `map(string)`  | `{}`           |    no    |
| <a name="input_client_cert_enabled"></a> [client_cert_enabled](#input_client_cert_enabled)                                           | (Optional) Does the App Service require client certificates for incoming requests? Defaults to false.                                                                                                                                             | `bool`         | `false`        |    no    |
| <a name="input_ftps_state"></a> [ftps_state](#input_ftps_state)                                                                      | (Optional) Enable FTPS connection ( Default: Disabled )                                                                                                                                                                                           | `string`       | `"Disabled"`   |    no    |
| <a name="input_health_check_path"></a> [health_check_path](#input_health_check_path)                                                 | (Optional) The health check path to be pinged by App Service.                                                                                                                                                                                     | `string`       | `null`         |    no    |
| <a name="input_linux_fx_version"></a> [linux_fx_version](#input_linux_fx_version)                                                    | (Optional) Linux App Framework and version for the App Service.                                                                                                                                                                                   | `string`       | `null`         |    no    |
| <a name="input_location"></a> [location](#input_location)                                                                            | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.                                                                                                                   | `string`       | `"westeurope"` |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                                        | (Required) Specifies the name of the App Service. Changing this forces a new resource to be created.                                                                                                                                              | `string`       | n/a            |   yes    |
| <a name="input_plan_id"></a> [plan_id](#input_plan_id)                                                                               | (Optional only if plan_type=internal) Specifies the external app service plan id.                                                                                                                                                                 | `string`       | `null`         |    no    |
| <a name="input_plan_kind"></a> [plan_kind](#input_plan_kind)                                                                         | (Optional) The kind of the App Service Plan to create. Possible values are Windows (also available as App), Linux, elastic (for Premium Consumption) and FunctionApp (for a Consumption Plan). Changing this forces a new resource to be created. | `string`       | `null`         |    no    |
| <a name="input_plan_maximum_elastic_worker_count"></a> [plan_maximum_elastic_worker_count](#input_plan_maximum_elastic_worker_count) | (Optional) The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan.                                                                                                                                             | `number`       | `null`         |    no    |
| <a name="input_plan_name"></a> [plan_name](#input_plan_name)                                                                         | (Optional) Specifies the name of the App Service Plan component. Changing this forces a new resource to be created.                                                                                                                               | `string`       | `null`         |    no    |
| <a name="input_plan_per_site_scaling"></a> [plan_per_site_scaling](#input_plan_per_site_scaling)                                     | (Optional) Can Apps assigned to this App Service Plan be scaled independently? If set to false apps assigned to this plan will scale to all instances of the plan. Defaults to false.                                                             | `bool`         | `false`        |    no    |
| <a name="input_plan_reserved"></a> [plan_reserved](#input_plan_reserved)                                                             | (Optional) Is this App Service Plan Reserved. When creating a Linux App Service Plan, the reserved field must be set to true, and when creating a Windows/app App Service Plan the reserved field must be set to false.                           | `bool`         | `null`         |    no    |
| <a name="input_plan_sku_size"></a> [plan_sku_size](#input_plan_sku_size)                                                             | (Optional) Specifies the plan's instance size.                                                                                                                                                                                                    | `string`       | `null`         |    no    |
| <a name="input_plan_sku_tier"></a> [plan_sku_tier](#input_plan_sku_tier)                                                             | (Optional) Specifies the plan's pricing tier.                                                                                                                                                                                                     | `string`       | `null`         |    no    |
| <a name="input_plan_type"></a> [plan_type](#input_plan_type)                                                                         | (Required) Specifies if app service plan is external or internal                                                                                                                                                                                  | `string`       | `"internal"`   |    no    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                                           | (Required) The name of the resource group in which to create the App Service and App Service Plan.                                                                                                                                                | `string`       | n/a            |   yes    |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id)                                                                         | (Optional) Subnet id wether you want to integrate the app service to a subnet.                                                                                                                                                                    | `string`       | `null`         |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                        | n/a                                                                                                                                                                                                                                               | `map(any)`     | n/a            |   yes    |
| <a name="input_vnet_integration"></a> [vnet_integration](#input_vnet_integration)                                                    | (optional) enable vnet integration. Wheter it's true the subnet_id should not be null.                                                                                                                                                            | `bool`         | `false`        |    no    |
| <a name="input_vnet_route_all_enabled"></a> [vnet_route_all_enabled](#input_vnet_route_all_enabled)                                  | Should all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied?                                                                                                                                              | `bool`         | `true`         |    no    |

## Outputs

| Name                                                                                                                       | Description |
| -------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_custom_domain_verification_id"></a> [custom_domain_verification_id](#output_custom_domain_verification_id) | n/a         |
| <a name="output_default_site_hostname"></a> [default_site_hostname](#output_default_site_hostname)                         | n/a         |
| <a name="output_id"></a> [id](#output_id)                                                                                  | n/a         |
| <a name="output_name"></a> [name](#output_name)                                                                            | n/a         |
| <a name="output_plan_id"></a> [plan_id](#output_plan_id)                                                                   | n/a         |
| <a name="output_plan_name"></a> [plan_name](#output_plan_name)                                                             | n/a         |
| <a name="output_principal_id"></a> [principal_id](#output_principal_id)                                                    | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

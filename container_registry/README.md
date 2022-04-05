<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.80.0, <= 2.99.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | (Optional) Specifies whether the admin user is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_anonymous_pull_enabled"></a> [anonymous\_pull\_enabled](#input\_anonymous\_pull\_enabled) | (Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? Defaults to false. This is only supported on resources with the Standard or Premium SKU. | `bool` | `false` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | A list of Azure locations where the container registry should be geo-replicated. | <pre>list(object({<br>    location                  = string<br>    regional_endpoint_enabled = bool<br>    zone_redundancy_enabled   = bool<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network_rule_bypass_option"></a> [network\_rule\_bypass\_option](#input\_network\_rule\_bypass\_option) | (Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices. | `string` | `"AzureServices"` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | (Required) Enable private endpoint with required params | <pre>object({<br>    enabled              = bool<br>    virtual_network_id   = string<br>    subnet_id            = string<br>    private_dns_zone_ids = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether public network access is allowed for the container registry. Defaults to true. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium. | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | (Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false. | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | n/a |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip_configurations"></a> [ip\_configurations](#input\_ip\_configurations) | n/a | <pre>list(object({<br>    name      = string<br>    subnet_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Firewall name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | Public ip address id, wether already defined. | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Sku name of the Firewall. | `string` | `null` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | Sku tier of the Firewall. | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_ip_configuration"></a> [ip\_configuration](#output\_ip\_configuration) | n/a |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| [azurerm_api_management_api.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_operation_policy.api_operation_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_product_api.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_api) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | n/a | `string` | n/a | yes |
| <a name="input_api_operation_policies"></a> [api\_operation\_policies](#input\_api\_operation\_policies) | List of api policy for given operation. | <pre>list(object({<br>    operation_id = string<br>    xml_content  = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | The Version number of this API, if this API is versioned. | `string` | `null` | no |
| <a name="input_content_format"></a> [content\_format](#input\_content\_format) | The format of the content from which the API Definition should be imported. | `string` | `"swagger-json"` | no |
| <a name="input_content_value"></a> [content\_value](#input\_content\_value) | The Content from which the API Definition should be imported. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | n/a | `string` | n/a | yes |
| <a name="input_product_ids"></a> [product\_ids](#input\_product\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_protocols"></a> [protocols](#input\_protocols) | n/a | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_revision"></a> [revision](#input\_revision) | n/a | `string` | `"1"` | no |
| <a name="input_service_url"></a> [service\_url](#input\_service\_url) | n/a | `string` | n/a | yes |
| <a name="input_subscription_required"></a> [subscription\_required](#input\_subscription\_required) | Should this API require a subscription key? | `bool` | `false` | no |
| <a name="input_version_set_id"></a> [version\_set\_id](#input\_version\_set\_id) | The ID of the Version Set which this API is associated with. | `string` | `null` | no |
| <a name="input_xml_content"></a> [xml\_content](#input\_xml\_content) | The XML Content for this Policy as a string | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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
| [azurerm_advanced_threat_protection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_management_lock.management_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_template_deployment.versioning](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | n/a | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. | `string` | `null` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | n/a | `string` | `"StorageV2"` | no |
| <a name="input_advanced_threat_protection"></a> [advanced\_threat\_protection](#input\_advanced\_threat\_protection) | n/a | `string` | `false` | no |
| <a name="input_allow_blob_public_access"></a> [allow\_blob\_public\_access](#input\_allow\_blob\_public\_access) | Allow or disallow public access to all blobs or containers in the storage account. | `bool` | `false` | no |
| <a name="input_blob_properties_delete_retention_policy_days"></a> [blob\_properties\_delete\_retention\_policy\_days](#input\_blob\_properties\_delete\_retention\_policy\_days) | Enable soft delete policy and specify the number of days that the blob should be retained | `number` | `null` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | n/a | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable versioning in the blob storage account. | `bool` | `false` | no |
| <a name="input_error_404_document"></a> [error\_404\_document](#input\_error\_404\_document) | n/a | `string` | `null` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | n/a | `string` | `null` | no |
| <a name="input_lock_enabled"></a> [lock\_enabled](#input\_lock\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | n/a | `string` | `null` | no |
| <a name="input_lock_name"></a> [lock\_name](#input\_lock\_name) | n/a | `string` | `null` | no |
| <a name="input_lock_notes"></a> [lock\_notes](#input\_lock\_notes) | n/a | `string` | `null` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | n/a | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | n/a | <pre>object({<br>    default_action             = string # Valid option Deny Allow<br>    bypass                     = set(string)<br>    ip_rules                   = list(string)<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_versioning_name"></a> [versioning\_name](#input\_versioning\_name) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | n/a |
| <a name="output_primary_blob_connection_string"></a> [primary\_blob\_connection\_string](#output\_primary\_blob\_connection\_string) | n/a |
| <a name="output_primary_blob_host"></a> [primary\_blob\_host](#output\_primary\_blob\_host) | n/a |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | n/a |
| <a name="output_primary_web_host"></a> [primary\_web\_host](#output\_primary\_web\_host) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

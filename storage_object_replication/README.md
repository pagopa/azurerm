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
| [azurerm_storage_object_replication.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_object_replication) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_storage_account_id"></a> [destination\_storage\_account\_id](#input\_destination\_storage\_account\_id) | The ID of the destination storage account. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | n/a | <pre>list(<br>    object({<br>      source_container_name      = string<br>      destination_container_name = string<br>      copy_blobs_created_after   = string<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_source_storage_account_id"></a> [source\_storage\_account\_id](#input\_source\_storage\_account\_id) | The ID of the source storage account. | `string` | n/a | yes |

## Outputs

No outputs.

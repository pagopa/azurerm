<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version              |
|------|----------------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0             |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.80.0, <= 2.99.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | <= 3.2.1             |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.80.0, <= 2.99.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_ssh_public_key.this_public_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ssh_public_key) | resource |
| [tls_private_key.this_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | (Optional) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. will be stored in the raw state as plain-text | `string` | `null` | no |
| <a name="input_authentication_type"></a> [authentication\_type](#input\_authentication\_type) | (Required) Type of authentication to use with the VM. Defaults to password for Windows and SSH public key for Linux. all enables both ssh and password authentication. | `string` | `"SSH"` | no |
| <a name="input_encryption_set_id"></a> [encryption\_set\_id](#input\_encryption\_set\_id) | (Optional) An existing encryption set | `string` | `null` | no |
| <a name="input_image_reference"></a> [image\_reference](#input\_image\_reference) | (Optional) A source\_image\_reference block as defined below. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | <pre>{<br>  "offer": "0001-com-ubuntu-server-jammy",<br>  "publisher": "Canonical",<br>  "sku": "22_04-lts-gen2",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_image_type"></a> [image\_type](#input\_image\_type) | (Required) Defines the source image to be used, whether 'custom' or 'standard'. `custom` requires `source_image_name` to be defined, `standard` requires `image_reference` | `string` | `"custom"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Linux Virtual Machine Scale Set. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_source_image_name"></a> [source\_image\_name](#input\_source\_image\_name) | (Optional) The name of an Image which each Virtual Machine in this Scale Set should be based on. It must be stored in the same subscription & resource group of this resource | `string` | n/a | yes |
| <a name="input_storage_sku"></a> [storage\_sku](#input\_storage\_sku) | (Optional) The SKU of the storage account with which to persist VM. Use a singular sku that would be applied across all disks, or specify individual disks. Usage: [--storage-sku SKU \| --storage-sku ID=SKU ID=SKU ID=SKU...], where each ID is os or a 0-indexed lun. Allowed values: Standard\_LRS, Premium\_LRS, StandardSSD\_LRS, UltraSSD\_LRS, Premium\_ZRS, StandardSSD\_ZRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) An existing subnet ID | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | (Required) Azure subscription id | `string` | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | (Required) Azure subscription name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | (Optional) Size of VMs in the scale set. Default to Standard\_B1s. See https://azure.microsoft.com/pricing/details/virtual-machines/ for size info. | `string` | `"Standard_B1s"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

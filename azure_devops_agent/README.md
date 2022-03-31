<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.80.0, <= 2.99.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authentication_type"></a> [authentication\_type](#input\_authentication\_type) | (Required) Type of authentication to use with the VM. Defaults to password for Windows and SSH public key for Linux. all enables both ssh and password authentication. | `string` | `"SSH"` | no |
| <a name="input_image"></a> [image](#input\_image) | (Optional) The name of the operating system image as a URN alias, URN, custom image name or ID, or VHD blob URI. Valid URN format: Publisher:Offer:Sku:Version. | `string` | `"UbuntuLTS"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Linux Virtual Machine Scale Set. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_storage_sku"></a> [storage\_sku](#input\_storage\_sku) | (Optional) The SKU of the storage account with which to persist VM. Use a singular sku that would be applied across all disks, or specify individual disks. Usage: [--storage-sku SKU \| --storage-sku ID=SKU ID=SKU ID=SKU...], where each ID is os or a 0-indexed lun. Allowed values: Standard\_LRS, Premium\_LRS, StandardSSD\_LRS, UltraSSD\_LRS, Premium\_ZRS, StandardSSD\_ZRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) An existing subnet ID | `string` | `null` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | (Required) Azure subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | (Optional) Size of VMs in the scale set. Default to Standard\_B1s. See https://azure.microsoft.com/pricing/details/virtual-machines/ for size info. | `string` | `"Standard_B1s"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

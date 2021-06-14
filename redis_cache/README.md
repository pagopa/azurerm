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
| [azurerm_redis_cache.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_family"></a> [family](#input\_family) | The SKU family/pricing group to use | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the resource group. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Redis instance. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU of Redis to use | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | n/a | <pre>object({<br>    frequency                 = number<br>    max_snapshot_count        = number<br>    storage_connection_string = string<br>  })</pre> | `null` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache to deploy | `number` | `1` | no |
| <a name="input_enable_authentication"></a> [enable\_authentication](#input\_enable\_authentication) | If set to false, the Redis instance will be accessible without authentication. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_non_ssl_port"></a> [enable\_non\_ssl\_port](#input\_enable\_non\_ssl\_port) | Enable the non-SSL port (6379) - disabled by default. | `bool` | `false` | no |
| <a name="input_patch_schedules"></a> [patch\_schedules](#input\_patch\_schedules) | n/a | <pre>list(object({<br>    day_of_week    = string<br>    start_hour_utc = number<br>  }))</pre> | `[]` | no |
| <a name="input_private_static_ip_address"></a> [private\_static\_ip\_address](#input\_private\_static\_ip\_address) | The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network | `string` | `null` | no |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | The number of Shards to create on the Redis Cluster. | `number` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The Subnet within which the Redis Cache should be deployed. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | n/a |
| <a name="output_ssl_port"></a> [ssl\_port](#output\_ssl\_port) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

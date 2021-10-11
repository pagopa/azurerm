Storage account
**/

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cdn_storage_account"></a> [cdn\_storage\_account](#module\_cdn\_storage\_account) | git::https://github.com/pagopa/azurerm.git//storage_account | v1.0.7 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_endpoint) | resource |
| [azurerm_cdn_profile.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_profile) | resource |
| [azurerm_dns_a_record.hostname](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_cname_record.cdnverify](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [null_resource.custom_domain](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | n/a | `string` | n/a | yes |
| <a name="input_dns_zone_resource_group_name"></a> [dns\_zone\_resource\_group\_name](#input\_dns\_zone\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_lock_enabled"></a> [lock\_enabled](#input\_lock\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_delivery_rule_redirect"></a> [delivery\_rule\_redirect](#input\_delivery\_rule\_redirect) | n/a | <pre>list(object({<br>    name         = string<br>    order        = number<br>    operator     = string<br>    match_values = list(string)<br>    url_redirect_action = object({<br>      redirect_type = string<br>      protocol      = string<br>      hostname      = string<br>      path          = string<br>      fragment      = string<br>      query_string  = string<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_delivery_rule_request_scheme_condition"></a> [delivery\_rule\_request\_scheme\_condition](#input\_delivery\_rule\_request\_scheme\_condition) | n/a | <pre>list(object({<br>    name         = string<br>    order        = number<br>    operator     = string<br>    match_values = list(string)<br>    url_redirect_action = object({<br>      redirect_type = string<br>      protocol      = string<br>      hostname      = string<br>      path          = string<br>      fragment      = string<br>      query_string  = string<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_delivery_rule_url_path_condition_cache_expiration_action"></a> [delivery\_rule\_url\_path\_condition\_cache\_expiration\_action](#input\_delivery\_rule\_url\_path\_condition\_cache\_expiration\_action) | n/a | <pre>list(object({<br>    name            = string<br>    order           = number<br>    operator        = string<br>    match_values    = list(string)<br>    behavior        = string<br>    duration        = string<br>    response_action = string<br>    response_name   = string<br>    response_value  = string<br>  }))</pre> | `[]` | no |
| <a name="input_global_delivery_rule"></a> [global\_delivery\_rule](#input\_global\_delivery\_rule) | n/a | <pre>object({<br>    cache_expiration_action = list(object({<br>      behavior = string<br>      duration = string<br>    }))<br>    cache_key_query_string_action = list(object({<br>      behavior   = string<br>      parameters = string<br>    }))<br>    modify_request_header_action = list(object({<br>      action = string<br>      name   = string<br>      value  = string<br>    }))<br>    modify_response_header_action = list(object({<br>      action = string<br>      name   = string<br>      value  = string<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_https_rewrite_enabled"></a> [https\_rewrite\_enabled](#input\_https\_rewrite\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_querystring_caching_behaviour"></a> [querystring\_caching\_behaviour](#input\_querystring\_caching\_behaviour) | n/a | `string` | `"IgnoreQueryString"` | no |
| <a name="input_storage_access_tier"></a> [storage\_access\_tier](#input\_storage\_access\_tier) | n/a | `string` | `"Hot"` | no |
| <a name="input_storage_account_kind"></a> [storage\_account\_kind](#input\_storage\_account\_kind) | n/a | `string` | `"StorageV2"` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | n/a | `string` | `"GRS"` | no |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | n/a | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |

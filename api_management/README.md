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
| [azurerm_api_management.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_diagnostic.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_diagnostic) | resource |
| [azurerm_api_management_logger.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_logger) | resource |
| [azurerm_api_management_redis_cache.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_redis_cache) | resource |
| [azurerm_monitor_metric_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | The email of publisher/company. | `string` | n/a | yes |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | The name of publisher/company. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_action"></a> [action](#input\_action) | The ID of the Action Group and optional map of custom string properties to include with the post webhook operation. | <pre>set(object(<br>    {<br>      action_group_id    = string<br>      webhook_properties = map(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_alert_enabled"></a> [alert\_enabled](#input\_alert\_enabled) | Should Metrics Alert be enabled? | `bool` | `true` | no |
| <a name="input_application_insights_instrumentation_key"></a> [application\_insights\_instrumentation\_key](#input\_application\_insights\_instrumentation\_key) | The instrumentation key used to push data to Application Insights. | `string` | `null` | no |
| <a name="input_diagnostic_always_log_errors"></a> [diagnostic\_always\_log\_errors](#input\_diagnostic\_always\_log\_errors) | Always log errors. Send telemetry if there is an erroneous condition, regardless of sampling settings. | `bool` | `true` | no |
| <a name="input_diagnostic_backend_request"></a> [diagnostic\_backend\_request](#input\_diagnostic\_backend\_request) | Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1 | <pre>set(object(<br>    {<br>      body_bytes     = number<br>      headers_to_log = set(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_diagnostic_backend_response"></a> [diagnostic\_backend\_response](#input\_diagnostic\_backend\_response) | Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1 | <pre>set(object(<br>    {<br>      body_bytes     = number<br>      headers_to_log = set(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_diagnostic_frontend_request"></a> [diagnostic\_frontend\_request](#input\_diagnostic\_frontend\_request) | Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1 | <pre>set(object(<br>    {<br>      body_bytes     = number<br>      headers_to_log = set(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_diagnostic_frontend_response"></a> [diagnostic\_frontend\_response](#input\_diagnostic\_frontend\_response) | Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1 | <pre>set(object(<br>    {<br>      body_bytes     = number<br>      headers_to_log = set(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_diagnostic_http_correlation_protocol"></a> [diagnostic\_http\_correlation\_protocol](#input\_diagnostic\_http\_correlation\_protocol) | The HTTP Correlation Protocol to use. Possible values are None, Legacy or W3C. | `string` | `"W3C"` | no |
| <a name="input_diagnostic_log_client_ip"></a> [diagnostic\_log\_client\_ip](#input\_diagnostic\_log\_client\_ip) | Log client IP address. | `bool` | `true` | no |
| <a name="input_diagnostic_sampling_percentage"></a> [diagnostic\_sampling\_percentage](#input\_diagnostic\_sampling\_percentage) | Sampling (%). For high traffic APIs, please read the documentation to understand performance implications and log sampling. Valid values are between 0.0 and 100.0. | `number` | `5` | no |
| <a name="input_diagnostic_verbosity"></a> [diagnostic\_verbosity](#input\_diagnostic\_verbosity) | Logging verbosity. Possible values are verbose, information or error. | `string` | `"error"` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br>    description = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br>    frequency = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br>    window_size = string<br><br>    criteria = set(object(<br>      {<br>        # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>        aggregation = string<br>        dimension = list(object(<br>          {<br>            name     = string<br>            operator = string<br>            values   = list(string)<br>          }<br>        ))<br>        metric_name      = string<br>        metric_namespace = string<br>        # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br>        operator               = string<br>        skip_metric_validation = bool<br>        threshold              = number<br>      }<br>    ))<br><br>    dynamic_criteria = set(object(<br>      {<br>        # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>        aggregation       = string<br>        alert_sensitivity = string<br>        dimension = list(object(<br>          {<br>            name     = string<br>            operator = string<br>            values   = list(string)<br>          }<br>        ))<br>        evaluation_failure_count = number<br>        evaluation_total_count   = number<br>        ignore_data_before       = string<br>        metric_name              = string<br>        metric_namespace         = string<br>        operator                 = string<br>        skip_metric_validation   = bool<br>      }<br>    ))<br>  }))</pre> | `{}` | no |
| <a name="input_notification_sender_email"></a> [notification\_sender\_email](#input\_notification\_sender\_email) | Email address from which the notification will be sent. | `string` | `null` | no |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | n/a | `string` | `null` | no |
| <a name="input_redis_connection_string"></a> [redis\_connection\_string](#input\_redis\_connection\_string) | Connection string for redis external cache | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | n/a | `string` | `"A string consisting of two parts separated by an underscore(_). The first part is the name, valid values include: Consumption, Developer, Basic, Standard and Premium. The second part is the capacity (e.g. the number of deployed units of the sku), which must be a positive integer (e.g. Developer_1)."` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The id of the subnet that will be used for the API Management. | `string` | `null` | no |
| <a name="input_virtual_network_type"></a> [virtual\_network\_type](#input\_virtual\_network\_type) | The type of virtual network you want to use, valid values include. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostic_id"></a> [diagnostic\_id](#output\_diagnostic\_id) | n/a |
| <a name="output_gateway_hostname"></a> [gateway\_hostname](#output\_gateway\_hostname) | n/a |
| <a name="output_gateway_url"></a> [gateway\_url](#output\_gateway\_url) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | n/a |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | n/a |

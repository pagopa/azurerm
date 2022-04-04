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
| [azurerm_monitor_metric_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_template_deployment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) | resource |
| [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions"></a> [actions](#input\_actions) | n/a | <pre>list(object({<br>    action_group_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_application_insight_name"></a> [application\_insight\_name](#input\_application\_insight\_name) | Application insight instance name. | `string` | n/a | yes |
| <a name="input_auto_mitigate"></a> [auto\_mitigate](#input\_auto\_mitigate) | (Optional) Should the alerts in this Metric Alert be auto resolved? Defaults to false. | `bool` | `false` | no |
| <a name="input_content_validation"></a> [content\_validation](#input\_content\_validation) | Required text that should appear in the response for this WebTest. | `string` | `"null"` | no |
| <a name="input_expected_http_status"></a> [expected\_http\_status](#input\_expected\_http\_status) | Expeced http status code. | `number` | `200` | no |
| <a name="input_failed_location_count"></a> [failed\_location\_count](#input\_failed\_location\_count) | The number of failed locations. | `number` | `1` | no |
| <a name="input_frequency"></a> [frequency](#input\_frequency) | Interval in seconds between test runs for this WebTest. | `number` | `300` | no |
| <a name="input_ignore_http_status"></a> [ignore\_http\_status](#input\_ignore\_http\_status) | Ignore http status code. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Application insight location. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Web test name | `string` | n/a | yes |
| <a name="input_request_url"></a> [request\_url](#input\_request\_url) | Url to check. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group name | `string` | n/a | yes |
| <a name="input_severity"></a> [severity](#input\_severity) | The severity of this Metric Alert. | `number` | `1` | no |
| <a name="input_ssl_cert_remaining_lifetime_check"></a> [ssl\_cert\_remaining\_lifetime\_check](#input\_ssl\_cert\_remaining\_lifetime\_check) | Days before the ssl certificate will expire. An expiry certificate will cause the test failing. | `number` | `7` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | (Required) subscription id. | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Seconds until this WebTest will timeout and fail. | `number` | `30` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

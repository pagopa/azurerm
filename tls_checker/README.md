# TLS Checker

This module allow the creation of the tls checker project as helm chart inside aks, and an alert reading custom metrics written by the tls checker that allows to trigger an alert

## How to use it

```ts
tls_checker_https_endpoints_to_check = [
  {
    https_endpoint = "api.dev.platform.pagopa.it",
    alert_name = "api-dev-platform-pagopa-it"
    alert_enabled = true,
    helm_present = true,
  },
]

module "tls_checker" {
  source = "git::https://github.com/pagopa/azurerm.git//tls_checker?ref=tls-checker-module"

  for_each = { for chkr in var.tls_checker_https_endpoints_to_check : chkr.alert_name => chkr }

  https_endpoint                             = each.value.https_endpoint
  alert_name                                 = each.value.alert_name
  alert_enabled                              = each.value.alert_enabled
  helm_chart_present                         = each.value.helm_present
  helm_chart_version                         = var.tls_cert_check_helm.chart_version
  namespace                                  = kubernetes_namespace.monitoring.metadata[0].name
  helm_chart_image_name                      = var.tls_cert_check_helm.image_name
  helm_chart_image_tag                       = var.tls_cert_check_helm.image_tag
  location_string                            = var.location_string
  application_insights_connection_string     = data.azurerm_application_insights.application_insights.connection_string
  application_insights_resource_group        = data.azurerm_resource_group.monitor_rg.name
  application_insights_id                    = data.azurerm_application_insights.application_insights.id
  application_insights_action_group_ids      = [data.azurerm_monitor_action_group.slack.id, data.azurerm_monitor_action_group.email.id]
}
```

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.80.0, <= 3.28.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | <= 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.80.0, <= 3.28.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | <= 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_metric_alert.alert_this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [helm_release.helm_this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_enabled"></a> [alert\_enabled](#input\_alert\_enabled) | (Optional) Is this alert enabled? | `bool` | `true` | no |
| <a name="input_alert_name"></a> [alert\_name](#input\_alert\_name) | (Optional) Alert name | `string` | `null` | no |
| <a name="input_application_insights_action_group_ids"></a> [application\_insights\_action\_group\_ids](#input\_application\_insights\_action\_group\_ids) | (Required) Application insights action group ids | `list(string)` | n/a | yes |
| <a name="input_application_insights_connection_string"></a> [application\_insights\_connection\_string](#input\_application\_insights\_connection\_string) | (Required) Application Insights connection string | `string` | n/a | yes |
| <a name="input_application_insights_id"></a> [application\_insights\_id](#input\_application\_insights\_id) | (Required) Application Insights id | `string` | n/a | yes |
| <a name="input_application_insights_resource_group"></a> [application\_insights\_resource\_group](#input\_application\_insights\_resource\_group) | (Required) Application Insights resource group | `string` | n/a | yes |
| <a name="input_expiration_delta_in_days"></a> [expiration\_delta\_in\_days](#input\_expiration\_delta\_in\_days) | (Optional) | `string` | `"7"` | no |
| <a name="input_helm_chart_image_name"></a> [helm\_chart\_image\_name](#input\_helm\_chart\_image\_name) | Docker image name | `string` | n/a | yes |
| <a name="input_helm_chart_image_tag"></a> [helm\_chart\_image\_tag](#input\_helm\_chart\_image\_tag) | Docker image tag | `string` | n/a | yes |
| <a name="input_helm_chart_present"></a> [helm\_chart\_present](#input\_helm\_chart\_present) | Is this helm chart present? | `bool` | `true` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Helm chart version for the tls checker application | `string` | n/a | yes |
| <a name="input_https_endpoint"></a> [https\_endpoint](#input\_https\_endpoint) | Https endpoint to check | `string` | n/a | yes |
| <a name="input_location_string"></a> [location\_string](#input\_location\_string) | (Required) Location string | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Required) Namespace where the helm chart will be installed | `string` | n/a | yes |
| <a name="input_time_trigger"></a> [time\_trigger](#input\_time\_trigger) | cron trigger pattern | `string` | `"*/1 * * * *"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

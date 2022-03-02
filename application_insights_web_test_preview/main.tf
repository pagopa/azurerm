locals {
  template_body = templatefile("${path.module}/template.tftpl", {
    subscription_id                   = var.subscription_id
    web_test_name                     = var.name
    resource_group                    = var.resource_group
    application_insight_name          = var.application_insight_name
    frequency                         = var.frequency
    timeout                           = var.timeout
    request_url                       = var.request_url
    expected_http_status              = var.expected_http_status
    ignore_http_status                = var.ignore_http_status
    content_validation                = var.content_validation
    ssl_cert_remaining_lifetime_check = var.ssl_cert_remaining_lifetime_check
    location                          = var.location
  })
}

data "azurerm_application_insights" "this" {
  name                = var.application_insight_name
  resource_group_name = var.resource_group
}

resource "azurerm_template_deployment" "this" {
  name                = var.name
  resource_group_name = var.resource_group

  template_body = local.template_body

  deployment_mode = "Incremental"
}

resource "azurerm_monitor_metric_alert" "this" {
  name                = format("%s-%s", var.name, var.application_insight_name)
  resource_group_name = var.resource_group
  severity            = var.severity
  scopes = [
    data.azurerm_application_insights.this.id,
    format("/subscriptions/%s/resourcegroups/%s/providers/microsoft.insights/webTests/%s-%s",
      var.subscription_id,
      var.resource_group,
      var.name,
      var.application_insight_name
    ),
  ]
  description   = "Web availability check alert triggered when it fails."
  auto_mitigate = var.auto_mitigate

  application_insights_web_test_location_availability_criteria {
    web_test_id = format("/subscriptions/%s/resourcegroups/%s/providers/microsoft.insights/webTests/%s-%s",
      var.subscription_id,
      var.resource_group,
      var.name,
      var.application_insight_name
    )
    component_id          = data.azurerm_application_insights.this.id
    failed_location_count = var.failed_location_count
  }

  dynamic "action" {
    for_each = var.actions
    content {
      action_group_id = action.value["action_group_id"]
    }
  }

  depends_on = [
    azurerm_template_deployment.this,
  ]
}

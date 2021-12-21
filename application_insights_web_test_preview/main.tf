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
    ssl_cert_remaining_lifetime_check = var.ssl_cert_remaining_lifetime_check
  })
}


resource "azurerm_template_deployment" "this" {
  name                = var.name
  resource_group_name = var.resource_group

  template_body = local.template_body

  deployment_mode = "Incremental"
}
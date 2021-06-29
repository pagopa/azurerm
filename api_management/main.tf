resource "azurerm_api_management" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  publisher_name            = var.publisher_name
  publisher_email           = var.publisher_email
  notification_sender_email = var.notification_sender_email
  sku_name                  = var.sku_name

  dynamic "policy" {
    for_each = var.policy_path != null ? ["dummy"] : []
    content {
      xml_content = file(var.policy_path)
    }
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_type = var.virtual_network_type

  dynamic "virtual_network_configuration" {
    for_each = contains(["Internal", "External"], var.virtual_network_type) ? ["dummy"] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  tags = var.tags
}

resource "azurerm_api_management_logger" "this" {
  count = var.application_insights_instrumentation_key != null ? 1 : 0

  name                = format("%s-logger", var.name)
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name

  application_insights {
    instrumentation_key = var.application_insights_instrumentation_key
  }
}

resource "azurerm_api_management_diagnostic" "this" {
  count = var.application_insights_instrumentation_key != null ? 1 : 0

  identifier               = "applicationinsights"
  resource_group_name      = var.resource_group_name
  api_management_name      = azurerm_api_management.this.name
  api_management_logger_id = azurerm_api_management_logger.this[0].id

  sampling_percentage       = var.diagnostic_sampling_percentage
  always_log_errors         = var.diagnostic_always_log_errors
  log_client_ip             = var.diagnostic_log_client_ip
  verbosity                 = var.diagnostic_verbosity
  http_correlation_protocol = var.diagnostic_http_correlation_protocol


  dynamic "backend_request" {
    for_each = var.diagnostic_backend_request
    content {
      # body_bytes - (optional) is a type of number
      body_bytes = backend_request.value["body_bytes"]
      # headers_to_log - (optional) is a type of set of string
      headers_to_log = backend_request.value["headers_to_log"]
    }
  }

  dynamic "backend_response" {
    for_each = var.diagnostic_backend_response
    content {
      # body_bytes - (optional) is a type of number
      body_bytes = backend_response.value["body_bytes"]
      # headers_to_log - (optional) is a type of set of string
      headers_to_log = backend_response.value["headers_to_log"]
    }
  }

  dynamic "frontend_request" {
    for_each = var.diagnostic_frontend_request
    content {
      # body_bytes - (optional) is a type of number
      body_bytes = frontend_request.value["body_bytes"]
      # headers_to_log - (optional) is a type of set of string
      headers_to_log = frontend_request.value["headers_to_log"]
    }
  }

  dynamic "frontend_response" {
    for_each = var.diagnostic_frontend_response
    content {
      # body_bytes - (optional) is a type of number
      body_bytes = frontend_response.value["body_bytes"]
      # headers_to_log - (optional) is a type of set of string
      headers_to_log = frontend_response.value["headers_to_log"]
    }
  }
}

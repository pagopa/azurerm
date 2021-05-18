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
  count               = var.application_insights_instrumentation_key != null ? 1 : 0
  name                = format("%s-logger", var.name)
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name

  application_insights {
    instrumentation_key = var.application_insights_instrumentation_key
  }
}
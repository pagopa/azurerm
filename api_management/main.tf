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

  dynamic "hostname_configuration" {
    for_each = var.hostname_configuration
    content {

      dynamic "developer_portal" {
        for_each = hostname_configuration.value.developer_portal
        content {
          # certificate - (optional) is a type of string
          certificate = developer_portal.value["certificate"]
          # certificate_password - (optional) is a type of string
          certificate_password = developer_portal.value["certificate_password"]
          # host_name - (required) is a type of string
          host_name = developer_portal.value["host_name"]
          # key_vault_id - (optional) is a type of string
          key_vault_id = developer_portal.value["key_vault_id"]
          # negotiate_client_certificate - (optional) is a type of bool
          negotiate_client_certificate = developer_portal.value["negotiate_client_certificate"]
        }
      }

      dynamic "management" {
        for_each = hostname_configuration.value.management
        content {
          # certificate - (optional) is a type of string
          certificate = management.value["certificate"]
          # certificate_password - (optional) is a type of string
          certificate_password = management.value["certificate_password"]
          # host_name - (required) is a type of string
          host_name = management.value["host_name"]
          # key_vault_id - (optional) is a type of string
          key_vault_id = management.value["key_vault_id"]
          # negotiate_client_certificate - (optional) is a type of bool
          negotiate_client_certificate = management.value["negotiate_client_certificate"]
        }
      }

      dynamic "portal" {
        for_each = hostname_configuration.value.portal
        content {
          # certificate - (optional) is a type of string
          certificate = portal.value["certificate"]
          # certificate_password - (optional) is a type of string
          certificate_password = portal.value["certificate_password"]
          # host_name - (required) is a type of string
          host_name = portal.value["host_name"]
          # key_vault_id - (optional) is a type of string
          key_vault_id = portal.value["key_vault_id"]
          # negotiate_client_certificate - (optional) is a type of bool
          negotiate_client_certificate = portal.value["negotiate_client_certificate"]
        }
      }

      dynamic "proxy" {
        for_each = hostname_configuration.value.proxy
        content {
          # certificate - (optional) is a type of string
          certificate = proxy.value["certificate"]
          # certificate_password - (optional) is a type of string
          certificate_password = proxy.value["certificate_password"]
          # default_ssl_binding - (optional) is a type of bool
          default_ssl_binding = proxy.value["default_ssl_binding"]
          # host_name - (required) is a type of string
          host_name = proxy.value["host_name"]
          # key_vault_id - (optional) is a type of string
          key_vault_id = proxy.value["key_vault_id"]
          # negotiate_client_certificate - (optional) is a type of bool
          negotiate_client_certificate = proxy.value["negotiate_client_certificate"]
        }
      }
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

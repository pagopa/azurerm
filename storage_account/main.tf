#tfsec:ignore:azure-storage-queue-services-logging-enabled
resource "azurerm_storage_account" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  allow_blob_public_access  = var.allow_blob_public_access
  is_hns_enabled            = var.is_hns_enabled

  dynamic "blob_properties" {
    for_each = var.blob_properties_delete_retention_policy_days == null ? [] : ["dummy"]
    content {
      delete_retention_policy {
        days = var.blob_properties_delete_retention_policy_days
      }
    }
  }

  dynamic "blob_properties" {
    for_each = ["dummy"]
    content {
      versioning_enabled = true
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]

    content {
      default_action             = length(network_rules.value.ip_rules) == 0 && length(network_rules.value.virtual_network_subnet_ids) == 0 ? network_rules.value.default_action : "Deny"
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  dynamic "static_website" {
    for_each = var.index_document != null && var.error_404_document != null ? ["dummy"] : []

    content {
      index_document     = var.index_document
      error_404_document = var.error_404_document
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain.name != null ? ["dummy"] : []

    content {
      name          = var.custom_domain.name
      use_subdomain = var.custom_domain.use_subdomain
    }
  }

  tags = var.tags
}

# Enable advanced threat protection
resource "azurerm_advanced_threat_protection" "this" {
  target_resource_id = azurerm_storage_account.this.id
  enabled            = var.advanced_threat_protection
}

# this is a tempory implementation till an official one will be released:
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/8268
resource "azurerm_template_deployment" "versioning" {
  count      = var.enable_versioning ? 1 : 0
  depends_on = [azurerm_storage_account.this]

  name                = var.versioning_name
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters = {
    "storageAccount" = azurerm_storage_account.this.name
  }

  template_body = <<DEPLOY
        {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "storageAccount": {
                    "type": "string",
                    "metadata": {
                        "description": "Storage Account Name"
                    }
                }
            },
            "variables": {},
            "resources": [
                {
                    "type": "Microsoft.Storage/storageAccounts/blobServices",
                    "apiVersion": "2019-06-01",
                    "name": "[concat(parameters('storageAccount'), '/default')]",
                    "properties": {
                        "IsVersioningEnabled": ${var.enable_versioning}
                    }
                }
            ]
        }
    DEPLOY
}

resource "azurerm_management_lock" "management_lock" {
  count      = var.lock_enabled ? 1 : 0
  depends_on = [azurerm_storage_account.this]

  name       = var.lock_name
  scope      = azurerm_storage_account.this.id
  lock_level = var.lock_level
  notes      = var.lock_notes
}

# -----------------------------------------------
# Alerts
# -----------------------------------------------

resource "azurerm_monitor_metric_alert" "storage_account_low_availability" {
  count = var.enable_low_availability_alert ? 1 : 0

  name                = "[${var.domain != null ? "${var.domain} | " : ""}${azurerm_storage_account.this.name}] Low Availability"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_storage_account.this.id]
  description         = "The average availability is less than 99.8%. Runbook: not needed."
  severity            = 0
  window_size         = "PT5M"
  frequency           = "PT5M"
  auto_mitigate       = false

  # Metric info
  # https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftstoragestorageaccounts
  criteria {
    metric_namespace       = "Microsoft.Storage/storageAccounts"
    metric_name            = "Availability"
    aggregation            = "Average"
    operator               = "LessThan"
    threshold              = var.low_availability_threshold
    skip_metric_validation = false
  }

  dynamic "action" {
    for_each = var.action
    content {
      action_group_id    = action.value["action_group_id"]
      webhook_properties = action.value["webhook_properties"]
    }
  }

  tags = var.tags
}

#tfsec:ignore:azure-storage-default-action-deny

module "storage_account_durable_function" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.7.0"

  name                       = coalesce(var.storage_account_durable_name, format("%ssdt", replace(var.name, "-", "")))
  account_kind               = var.storage_account_info.account_kind
  account_tier               = var.storage_account_info.account_tier
  account_replication_type   = var.storage_account_info.account_replication_type
  access_tier                = var.storage_account_info.account_kind != "Storage" ? var.storage_account_info.access_tier : null
  resource_group_name        = var.resource_group_name
  location                   = var.location
  advanced_threat_protection = false

  network_rules = {
    default_action = "Deny"
    ip_rules       = []
    bypass = [
      "Logging",
      "Metrics",
      "AzureServices",
    ]
    virtual_network_subnet_ids = [
      var.subnet_id
    ]
  }

  tags = var.tags
}

resource "azurerm_storage_queue" "internal_queue" {
  for_each             = toset(var.internal_queues)
  name                 = each.value
  storage_account_name = module.storage_account_durable_function[0].name
}

resource "azurerm_storage_container" "internal_container" {
  for_each              = toset(var.internal_containers)
  name                  = each.value
  storage_account_name  = module.storage_account_durable_function[0].name
  container_access_type = "private"
}

resource "azurerm_storage_table" "internal_tables" {
  for_each             = toset(var.internal_tables)
  name                 = each.value
  storage_account_name = module.storage_account_durable_function[0].name
}

module "storage_account_durable_function_management_policy" {
  count  = length(var.internal_containers) == 0 ? 0 : 1
  source = "git::https://github.com/pagopa/azurerm.git//storage_management_policy?ref=v3.6.1"

  storage_account_id = module.storage_account_durable_function[0].id

  rules = [
    {
      name    = "deleteafterdays"
      enabled = true
      filters = {
        prefix_match = var.internal_containers
        blob_types   = ["blockBlob"]
      }
      actions = {
        base_blob = {
          tier_to_cool_after_days_since_modification_greater_than    = 0
          tier_to_archive_after_days_since_modification_greater_than = 0
          delete_after_days_since_modification_greater_than          = var.blobs_retention_days
        }
        snapshot = null
      }
    },
  ]
}

resource "azurerm_private_endpoint" "blob" {
  name                = format("%s-blob-endpoint", module.storage_account_durable_function[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-blob", module.storage_account_durable_function[0].name)
    private_connection_resource_id = module.storage_account_durable_function[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_blob_ids
    content {
      name                 = "private-dns-zone-group"
      private_dns_zone_ids = var.private_dns_zone_blob_ids
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "queue" {
  name                = format("%s-queue-endpoint", module.storage_account_durable_function[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-queue", module.storage_account_durable_function[0].name)
    private_connection_resource_id = module.storage_account_durable_function[0].id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_queue_ids
    content {
      name                 = "private-dns-zone-group"
      private_dns_zone_ids = var.private_dns_zone_queue_ids
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "table" {
  name                = format("%s-table-endpoint", module.storage_account_durable_function[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-table", module.storage_account_durable_function[0].name)
    private_connection_resource_id = module.storage_account_durable_function[0].id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_table_ids
    content {
      name                 = "private-dns-zone-group"
      private_dns_zone_ids = var.private_dns_zone_table_ids
    }
  }

  tags = var.tags
}
#tfsec:ignore:azure-storage-default-action-deny
module "storage_account" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.58"

  name                       = coalesce(var.storage_account_name, format("%sst", replace(var.name, "-", "")))
  account_kind               = "StorageV2"
  account_tier               = var.storage_account_info.account_tier
  account_replication_type   = var.storage_account_info.account_replication_type
  access_tier                = var.storage_account_info.access_tier
  resource_group_name        = var.resource_group_name
  location                   = var.location
  advanced_threat_protection = var.storage_account_info.advanced_threat_protection_enable

  tags = var.tags
}

module "storage_account_durable_function" {
  count = var.durable_function.enable ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.58"

  name                       = format("%sst%sd", var.name)
  account_kind               = "StorageV2"
  account_tier               = var.storage_account_info.account_tier
  account_replication_type   = var.storage_account_info.account_replication_type
  access_tier                = var.storage_account_info.access_tier
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

resource "azurerm_private_endpoint" "blob" {
  count = var.durable_function.enable ? 1 : 0

  name                = format("%s-blob-endpoint", module.storage_account_durable_function[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.durable_function.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-blob", module.storage_account_durable_function[0].name)
    private_connection_resource_id = module.storage_account_durable_function[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.durable_function.private_dns_zone_blob_ids != null ? ["dummy"] : []
    content {
      name                 = "private-dns-zone-group"
      private_dns_zone_ids = var.durable_function.private_dns_zone_blob_ids
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "queue" {
  count = var.durable_function.enable ? 1 : 0

  name                = format("%s-queue-endpoint", module.storage_account_durable_function[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.durable_function.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-queue", module.storage_account_durable_function[0].name)
    private_connection_resource_id = module.storage_account_durable_function[0].id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.durable_function.private_dns_zone_queue_ids != null ? ["dummy"] : []
    content {
      name                 = "private-dns-zone-group"
      private_dns_zone_ids = var.durable_function.private_dns_zone_queue_ids
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "table" {
  count = var.durable_function.enable ? 1 : 0

  name                = format("%s-table-endpoint", module.storage_account_durable_function[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.durable_function.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-table", module.storage_account_durable_function[0].name)
    private_connection_resource_id = module.storage_account_durable_function[0].id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.durable_function.private_dns_zone_table_ids != null ? ["dummy"] : []
    content {
      name                 = "private-dns-zone-group"
      private_dns_zone_ids = var.durable_function.private_dns_zone_table_ids
    }
  }

  tags = var.tags
}

resource "azurerm_app_service_plan" "this" {
  count = var.app_service_plan_id == null ? 1 : 0

  name                = var.app_service_plan_name != null ? var.app_service_plan_name : format("%s-plan", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan_info.kind

  sku {
    tier = var.app_service_plan_info.sku_tier
    size = var.app_service_plan_info.sku_size
    # capacity is only for isolated envs
  }

  maximum_elastic_worker_count = var.app_service_plan_info.kind == "elastic" ? var.app_service_plan_info.maximum_elastic_worker_count : null
  reserved                     = var.app_service_plan_info.kind == "Linux" ? true : null
  per_site_scaling             = false

  tags = var.tags
}

locals {
  allowed_ips                                = [for ip in var.allowed_ips : { ip_address = ip, virtual_network_subnet_id = null }]
  allowed_subnets                            = [for s in var.allowed_subnets : { ip_address = null, virtual_network_subnet_id = s }]
  ip_restrictions                            = concat(local.allowed_subnets, local.allowed_ips)
  durable_function_storage_connection_string = var.durable_function.enable ? module.storage_account_durable_function[0].primary_connection_string : "dummy"
}

resource "azurerm_function_app" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  version                    = var.runtime_version
  app_service_plan_id        = var.app_service_plan_id != null ? var.app_service_plan_id : azurerm_app_service_plan.this[0].id
  storage_account_name       = module.storage_account.name
  storage_account_access_key = module.storage_account.primary_access_key
  https_only                 = true
  os_type                    = var.app_service_plan_info.kind == "Linux" ? "linux" : null

  auth_settings {
    enabled = true
  }

  site_config {
    min_tls_version           = "1.2"
    ftps_state                = "Disabled"
    http2_enabled             = true
    always_on                 = var.app_service_plan_info.sku_tier != "ElasticPremium" ? var.always_on : null
    pre_warmed_instance_count = var.pre_warmed_instance_count

    dynamic "ip_restriction" {
      for_each = local.ip_restrictions
      iterator = ip

      content {
        ip_address                = ip.value.ip_address
        virtual_network_subnet_id = ip.value.virtual_network_subnet_id
      }
    }

    dynamic "cors" {
      for_each = var.cors != null ? [var.cors] : []
      content {
        allowed_origins = cors.value.allowed_origins
      }
    }

    health_check_path = var.health_check_path

  }

  app_settings = merge(
    {
      APPINSIGHTS_INSTRUMENTATIONKEY = var.application_insights_instrumentation_key
      # No downtime on slots swap
      WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG = 1
      # default value for health_check_path, override it in var.app_settings if needed
      WEBSITE_HEALTHCHECK_MAXPINGFAILURES = var.health_check_path != null ? var.health_check_maxpingfailures : null
      # https://docs.microsoft.com/en-us/samples/azure-samples/azure-functions-private-endpoints/connect-to-private-endpoints-with-azure-functions/
      SLOT_TASK_HUBNAME               = "ProductionTaskHub"
      WEBSITE_RUN_FROM_PACKAGE        = 1
      WEBSITE_VNET_ROUTE_ALL          = 1
      WEBSITE_DNS_SERVER              = "168.63.129.16"
      APPINSIGHTS_SAMPLING_PERCENTAGE = 5
    },
    # this app settings is required to solve the issue:
    # https://github.com/terraform-providers/terraform-provider-azurerm/issues/10499
    # WEBSITE_CONTENTSHARE and WEBSITE_CONTENTAZUREFILECONNECTIONSTRING required only for ElasticPremium plan
    var.app_service_plan_info.sku_tier == "ElasticPremium" ? { WEBSITE_CONTENTSHARE = "${var.name}-content" } : {},
    var.durable_function.enable ? { DURABLE_FUNCTION_STORAGE_CONNECTION_STRING = local.durable_function_storage_connection_string } : {},
    var.app_settings,
  )

  enable_builtin_logging = false

  tags = var.tags
}

# this datasource has been introduced within version 2.27.0
data "azurerm_function_app_host_keys" "this" {
  count = var.export_keys ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_function_app.this]
}

resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_function_app.this.id
  subnet_id      = var.subnet_id
}

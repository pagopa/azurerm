locals {
  allowed_ips     = [for ip in var.allowed_ips : { ip_address = ip, virtual_network_subnet_id = null }]
  allowed_subnets = [for s in var.allowed_subnets : { ip_address = null, virtual_network_subnet_id = s }]
  ip_restrictions = concat(local.allowed_subnets, local.allowed_ips)
}

resource "azurerm_function_app_slot" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  version                    = var.runtime_version
  function_app_name          = var.function_app_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    min_tls_version           = "1.2"
    ftps_state                = "Disabled"
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

    auto_swap_slot_name = var.auto_swap_slot_name
    health_check_path   = var.health_check_path
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
    var.app_service_plan_sku == "ElasticPremium" ? { WEBSITE_CONTENTSHARE = "${var.name}-content" } : {},
    var.durable_function_storage_connection_string ? { DURABLE_FUNCTION_STORAGE_CONNECTION_STRING = var.durable_function_storage_connection_string } : {},
    var.app_settings,
  )

  enable_builtin_logging = false

  tags = var.tags

}

data "azurerm_function_app_host_keys" "this" {
  count               = var.export_keys ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_function_app_slot.this]
}

resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_function_app_slot.this
  subnet_id      = var.subnet_out_id
}

#tfsec:ignore:azure-storage-default-action-deny

locals {
  common_app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "14.16.0"
    WEBSITE_RUN_FROM_PACKAGE       = "1"
    WEBSITE_VNET_ROUTE_ALL         = "1"
    FUNCTIONS_WORKER_PROCESS_COUNT = 4
    NODE_ENV                       = "production"
  }
}

# Resource Groups for function app (one rg for each function instance)
resource "azurerm_resource_group" "function_app_rg" {
  count    = var.function_app_count
  name     = format("%s-rg-%d", var.name, count.index + 1)
  location = var.location

  tags = var.tags
}

# Subnet to host function app
module "app_snet" {
  count                                          = var.function_app_count
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v3.12.0"
  name                                           = format("%s-snet-%d", var.name, count.index + 1)
  address_prefixes                               = [var.cidr_subnet_app[count.index]]
  resource_group_name                            = var.vnet_resource_group
  virtual_network_name                           = var.vnet_name
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Storage",
  ]

  delegation = {
    name = "default"
    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

## Main slots
module "function_app" {
  count  = var.function_app_count
  source = "git::https://github.com/pagopa/azurerm.git//function_app?ref=v3.12.0"

  location = var.location
  domain   = var.domain
  name     = format("%s-fn-%d", var.name, count.index + 1)

  storage_account_name                     = var.storage_account_name
  storage_account_durable_name             = var.storage_account_durable_name
  app_service_plan_name                    = var.app_service_plan_name
  resource_group_name                      = azurerm_resource_group.function_app_rg[count.index].name
  runtime_version                          = var.runtime_version
  storage_account_info                     = var.storage_account_info
  app_service_plan_id                      = var.app_service_plan_id
  app_service_plan_info                    = var.app_service_plan_info
  pre_warmed_instance_count                = var.pre_warmed_instance_count
  always_on                                = var.always_on
  use_32_bit_worker_process                = var.use_32_bit_worker_process
  linux_fx_version                         = var.linux_fx_version
  application_insights_instrumentation_key = var.application_insights_instrumentation_key
  os_type                                  = var.os_type
  https_only                               = var.https_only
  allowed_ips                              = var.allowed_ips
  cors                                     = var.cors
  vnet_integration                         = var.vnet_integration
  internal_storage                         = var.internal_storage
  health_check_path                        = var.health_check_path
  health_check_maxpingfailures             = var.health_check_maxpingfailures
  export_keys                              = var.export_keys
  tags                                     = var.tags
  system_identity_enabled                  = var.system_identity_enabled
  enable_healthcheck                       = var.enable_healthcheck
  healthcheck_threshold                    = var.healthcheck_threshold
  action                                   = var.action

  subnet_id       = module.app_snet[count.index].id
  allowed_subnets = concat([module.app_snet[count.index].id], var.allowed_subnets)

  app_settings = merge(
    local.common_app_settings,
    {
      FEATURE_FLAG = false
    },
    var.app_settings,
  )
}

module "function_app_staging_slot" {
  count  = var.function_app_count
  source = "git::https://github.com/pagopa/azurerm.git//function_app_slot?ref=v3.12.0"

  name                = "staging"
  location            = var.location
  resource_group_name = azurerm_resource_group.function_app_rg[count.index].name
  function_app_name   = module.function_app[count.index].name
  function_app_id     = module.function_app[count.index].id
  app_service_plan_id = module.function_app[count.index].app_service_plan_id
  health_check_path   = var.health_check_path

  storage_account_name               = module.function_app[count.index].storage_account.name
  storage_account_access_key         = module.function_app[count.index].storage_account.primary_access_key
  internal_storage_connection_string = module.function_app[count.index].storage_account_internal_function.primary_connection_string

  os_type                                  = var.os_type
  linux_fx_version                         = var.linux_fx_version
  always_on                                = var.always_on
  runtime_version                          = var.runtime_version
  application_insights_instrumentation_key = var.application_insights_instrumentation_key
  tags                                     = var.tags
  pre_warmed_instance_count                = var.pre_warmed_instance_count
  use_32_bit_worker_process                = var.use_32_bit_worker_process
  allowed_ips                              = var.allowed_ips
  cors                                     = var.cors
  vnet_integration                         = var.vnet_integration
  https_only                               = var.https_only
  health_check_maxpingfailures             = var.health_check_maxpingfailures
  export_keys                              = var.export_keys

  subnet_id       = module.app_snet[count.index].id
  allowed_subnets = concat([module.app_snet[count.index].id, var.azdoa_snet_id], var.allowed_subnets)

  app_settings = merge(
    local.common_app_settings,
    {
      FEATURE_FLAG = false
    },
    var.app_settings,
  )
}
##

## Beta slot
module "storage_account_for_beta" {
  count  = var.internal_storage.enable ? 1 : 0
  source = "git::https://github.com/pagopa/azurerm.git//storage_account_for_function?ref=70e0b77d672e9c8939bab8897ea7f72ca0880ce0"

  location                   = var.location
  resource_group_name        = azurerm_resource_group.function_app_rg[count.index].name
  name                       = format("%sb", coalesce(var.storage_account_durable_name, format("%ssdt", replace(var.name, "-", ""))))
  subnet_id                  = module.app_snet[count.index].id
  internal_queues            = var.internal_storage.queues
  internal_containers        = var.internal_storage.containers
  blobs_retention_days       = var.internal_storage.blobs_retention_days
  private_endpoint_subnet_id = var.internal_storage.private_endpoint_subnet_id
  private_dns_zone_blob_ids  = var.internal_storage.private_dns_zone_blob_ids
  private_dns_zone_table_ids = var.internal_storage.private_dns_zone_table_ids
  private_dns_zone_queue_ids = var.internal_storage.private_dns_zone_queue_ids
  tags                       = var.tags
}

module "function_app_beta_slot" {
  count  = var.function_app_count
  source = "git::https://github.com/pagopa/azurerm.git//function_app_slot?ref=v3.12.0"

  name                = "beta"
  location            = var.location
  resource_group_name = azurerm_resource_group.function_app_rg[count.index].name
  function_app_name   = module.function_app[count.index].name
  function_app_id     = module.function_app[count.index].id
  app_service_plan_id = module.function_app[count.index].app_service_plan_id
  health_check_path   = var.health_check_path

  storage_account_name               = module.function_app[count.index].storage_account.name
  storage_account_access_key         = module.function_app[count.index].storage_account.primary_access_key
  internal_storage_connection_string = var.internal_storage.enable ? module.storage_account_for_beta[0].primary_connection_string : "dummy"

  os_type                                  = var.os_type
  linux_fx_version                         = var.linux_fx_version
  always_on                                = var.always_on
  runtime_version                          = var.runtime_version
  application_insights_instrumentation_key = var.application_insights_instrumentation_key
  tags                                     = var.tags
  pre_warmed_instance_count                = var.pre_warmed_instance_count
  use_32_bit_worker_process                = var.use_32_bit_worker_process
  allowed_ips                              = var.allowed_ips
  cors                                     = var.cors
  vnet_integration                         = var.vnet_integration
  https_only                               = var.https_only
  health_check_maxpingfailures             = var.health_check_maxpingfailures
  export_keys                              = var.export_keys

  subnet_id       = module.app_snet[count.index].id
  allowed_subnets = concat([module.app_snet[count.index].id, var.azdoa_snet_id], var.allowed_subnets)

  app_settings = merge(
    local.common_app_settings,
    {
      FEATURE_FLAG = true
    },
    var.app_settings,
  )

}
##

## Scaling
resource "azurerm_monitor_autoscale_setting" "function_app" {
  count               = var.function_app_count
  name                = format("%s-autoscale", module.function_app[count.index].name)
  resource_group_name = azurerm_resource_group.function_app_rg[count.index].name
  location            = var.location
  target_resource_id  = module.function_app[count.index].app_service_plan_id

  profile {
    name = "default"

    capacity {
      default = var.function_app_autoscale_default
      minimum = var.function_app_autoscale_minimum
      maximum = var.function_app_autoscale_maximum
    }

    rule {
      metric_trigger {
        metric_name              = "Requests"
        metric_resource_id       = module.function_app[count.index].id
        metric_namespace         = "microsoft.web/sites"
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "GreaterThan"
        threshold                = 3000
        divide_by_instance_count = false
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name              = "CpuPercentage"
        metric_resource_id       = module.function_app[count.index].app_service_plan_id
        metric_namespace         = "microsoft.web/serverfarms"
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "GreaterThan"
        threshold                = 45
        divide_by_instance_count = false
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name              = "Requests"
        metric_resource_id       = module.function_app[count.index].id
        metric_namespace         = "microsoft.web/sites"
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "LessThan"
        threshold                = 2000
        divide_by_instance_count = false
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT20M"
      }
    }

    rule {
      metric_trigger {
        metric_name              = "CpuPercentage"
        metric_resource_id       = module.function_app[count.index].app_service_plan_id
        metric_namespace         = "microsoft.web/serverfarms"
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "LessThan"
        threshold                = 30
        divide_by_instance_count = false
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT20M"
      }
    }
  }
}
##

## Alerts
resource "azurerm_monitor_metric_alert" "function_app_health_check" {
  count = var.function_app_count

  name                = "${module.function_app[count.index].name}-health-check-failed"
  resource_group_name = azurerm_resource_group.function_app_rg[count.index].name
  scopes              = [module.function_app[count.index].id]
  description         = "${module.function_app[count.index].name} health check failed"
  severity            = 1
  frequency           = "PT5M"
  auto_mitigate       = false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HealthCheckStatus"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 50
  }

  action {
    action_group_id = var.action_group_email_id
  }

  action {
    action_group_id = var.action_group_slack_id
  }
}
##

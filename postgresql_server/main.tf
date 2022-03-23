locals {
  # for B_Gen5_1 B_Gen5_2 must be true
  public_network_access_enabled = contains(["B_Gen5_1", "B_Gen5_2"], var.sku_name) ? true : var.public_network_access_enabled

  firewall_rules = [for rule in var.network_rules.ip_rules : {
    start : cidrhost(rule, 0)
    end : cidrhost(rule, pow(2, (32 - parseint(split("/", rule)[1], 10))) - 1)
  }]

  replica_firewall_rules = [for rule in var.replica_network_rules.ip_rules : {
    start : cidrhost(rule, 0)
    end : cidrhost(rule, pow(2, (32 - parseint(split("/", rule)[1], 10))) - 1)
  }]

  configuration_replica = var.enable_replica ? var.configuration_replica : {}

  monitor_metric_alert_criteria         = var.alerts_enabled ? var.monitor_metric_alert_criteria : {}
  replica_monitor_metric_alert_criteria = var.enable_replica && var.alerts_enabled ? var.replica_monitor_metric_alert_criteria : {}
}

resource "azurerm_postgresql_server" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name   = var.sku_name
  version    = var.db_version
  storage_mb = var.storage_mb

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  auto_grow_enabled                = true
  public_network_access_enabled    = local.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  create_mode               = var.create_mode
  creation_source_server_id = var.creation_source_server_id
  restore_point_in_time     = var.restore_point_in_time

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      # Autogrow is enabled
      storage_mb,
    ]
  }

  tags = var.tags
}

resource "azurerm_postgresql_server" "replica" {
  count = var.enable_replica ? 1 : 0

  name                = format("%s-rep", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name   = var.sku_name
  version    = var.db_version
  storage_mb = var.storage_mb

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  auto_grow_enabled = true

  public_network_access_enabled    = local.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  create_mode               = "Replica"
  creation_source_server_id = azurerm_postgresql_server.this.id

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      # Autogrow is enabled
      storage_mb,
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint.enabled ? 1 : 0

  name                = format("%s-private-endpoint", azurerm_postgresql_server.this.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint.subnet_id

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", azurerm_postgresql_server.this.name)
    private_dns_zone_ids = var.private_endpoint.private_dns_zone_ids
  }

  private_service_connection {
    name                           = format("%s-private-service-connection", azurerm_postgresql_server.this.name)
    private_connection_resource_id = azurerm_postgresql_server.this.id
    is_manual_connection           = false
    subresource_names              = ["postgreSqlServer"]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "replica" {
  count = var.enable_replica && var.private_endpoint.enabled ? 1 : 0

  name                = format("%s-private-endpoint", azurerm_postgresql_server.replica[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint.subnet_id

  private_service_connection {
    name                           = format("%s-private-service-connection", azurerm_postgresql_server.replica[0].name)
    private_connection_resource_id = azurerm_postgresql_server.replica[0].id
    is_manual_connection           = false
    subresource_names              = ["postgreSqlServer"]
  }

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", azurerm_postgresql_server.replica[0].name)
    private_dns_zone_ids = var.private_endpoint.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_postgresql_virtual_network_rule" "this" {
  count = length(var.allowed_subnets)

  name                                 = format("%s-vnet-rule-%d", azurerm_postgresql_server.this.name, count.index)
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.this.name
  subnet_id                            = var.allowed_subnets[count.index]
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "this" {
  count = local.public_network_access_enabled ? length(local.firewall_rules) : 0

  name                = format("%s-fw-rule-%d", azurerm_postgresql_server.this.name, count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = local.firewall_rules[count.index].start
  end_ip_address      = local.firewall_rules[count.index].end
}

resource "azurerm_postgresql_firewall_rule" "azure" {
  count = var.network_rules.allow_access_to_azure_services && local.public_network_access_enabled ? 1 : 0

  name                = format("%s-allow-azure-access", azurerm_postgresql_server.this.name)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_virtual_network_rule" "replica" {
  count = var.enable_replica ? length(var.replica_allowed_subnets) : 0

  name                                 = format("%s-vnet-rule-%d", azurerm_postgresql_server.replica[0].name, count.index)
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.replica[0].name
  subnet_id                            = var.replica_allowed_subnets[count.index]
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "replica" {
  count = var.enable_replica ? length(local.replica_firewall_rules) : 0

  name                = format("%s-fw-rule-%d", azurerm_postgresql_server.replica[0].name, count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  start_ip_address    = local.replica_firewall_rules[count.index].start
  end_ip_address      = local.replica_firewall_rules[count.index].end
}

resource "azurerm_postgresql_firewall_rule" "azure_replica" {
  count = var.enable_replica && var.replica_network_rules.allow_access_to_azure_services ? 1 : 0

  name                = format("%s-allow-azure-access", azurerm_postgresql_server.replica[0].name)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_configuration" "this" {
  for_each = var.configuration

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = each.value
}

resource "azurerm_postgresql_configuration" "replica" {
  for_each = local.configuration_replica

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  value               = each.value
}

resource "azurerm_monitor_metric_alert" "this" {
  for_each = local.monitor_metric_alert_criteria

  name                = format("%s-%s", azurerm_postgresql_server.this.name, upper(each.key))
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_postgresql_server.this.id]
  frequency           = each.value.frequency
  window_size         = each.value.window_size
  enabled             = var.alerts_enabled

  dynamic "action" {
    for_each = var.action
    content {
      # action_group_id - (required) is a type of string
      action_group_id = action.value["action_group_id"]
      # webhook_properties - (optional) is a type of map of string
      webhook_properties = action.value["webhook_properties"]
    }
  }

  criteria {
    aggregation      = each.value.aggregation
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = each.value.metric_name
    operator         = each.value.operator
    threshold        = each.value.threshold

    dynamic "dimension" {
      for_each = each.value.dimension
      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }
  }
}

resource "azurerm_monitor_metric_alert" "replica" {
  for_each = local.replica_monitor_metric_alert_criteria

  name                = format("%s-%s", azurerm_postgresql_server.replica[0].name, upper(each.key))
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_postgresql_server.replica[0].id]
  frequency           = each.value.frequency
  window_size         = each.value.window_size
  enabled             = var.alerts_enabled

  dynamic "action" {
    for_each = var.replica_action
    content {
      # action_group_id - (required) is a type of string
      action_group_id = action.value["action_group_id"]
      # webhook_properties - (optional) is a type of map of string
      webhook_properties = action.value["webhook_properties"]
    }
  }

  criteria {
    aggregation      = each.value.aggregation
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = each.value.metric_name
    operator         = each.value.operator
    threshold        = each.value.threshold

    dynamic "dimension" {
      for_each = each.value.dimension
      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }
  }
}

resource "azurerm_management_lock" "this" {
  count      = var.lock_enable ? 1 : 0
  name       = format("%s-lock", azurerm_postgresql_server.this.name)
  scope      = azurerm_postgresql_server.this.id
  lock_level = "CanNotDelete"
  notes      = "This items can't be deleted in this subscription!"
}

resource "azurerm_management_lock" "replica" {
  count      = var.enable_replica && var.lock_enable ? 1 : 0
  name       = format("%s-lock", azurerm_postgresql_server.replica[0].name)
  scope      = azurerm_postgresql_server.replica[0].id
  lock_level = "CanNotDelete"
  notes      = "This items can't be deleted in this subscription!"
}

# https://tfsec.dev/docs/azure/database/postgres-configuration-log-checkpoints/#azure/database

resource "azurerm_postgresql_configuration" "this_log_checkpoints" {
  name                = "log_checkpoints"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = "on"
}

resource "azurerm_postgresql_configuration" "replica_log_checkpoints" {
  count               = var.enable_replica ? 1 : 0
  name                = "log_checkpoints"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  value               = "on"
}

# https://tfsec.dev/docs/azure/database/postgres-configuration-log-connection-throttling/#azure/database

resource "azurerm_postgresql_configuration" "this_connection_throttling" {
  name                = "connection_throttling"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = "on"
}

resource "azurerm_postgresql_configuration" "replica_connection_throttling" {
  count               = var.enable_replica ? 1 : 0
  name                = "connection_throttling"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  value               = "on"
}

# https://tfsec.dev/docs/azure/database/postgres-configuration-log-connections/#azure/database

resource "azurerm_postgresql_configuration" "this_log_connections" {
  name                = "log_connections"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = "on"
}

resource "azurerm_postgresql_configuration" "replica_log_connections" {
  count               = var.enable_replica ? 1 : 0
  name                = "log_connections"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  value               = "on"
}

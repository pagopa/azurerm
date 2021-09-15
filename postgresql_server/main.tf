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

  auto_grow_enabled = true

  public_network_access_enabled    = var.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  create_mode               = var.create_mode
  creation_source_server_id = var.creation_source_server_id
  restore_point_in_time     = var.restore_point_in_time


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

  public_network_access_enabled    = var.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  create_mode               = "Replica"
  creation_source_server_id = azurerm_postgresql_server.this.id

  lifecycle {
    ignore_changes = [
      # Autogrow is enabled
      storage_mb,
    ]
  }

  tags = var.tags
}

locals {
  firewall_rules = [for rule in var.network_rules.ip_rules : {
    start : cidrhost(rule, 0)
    end : cidrhost(rule, pow(2, (32 - parseint(split("/", rule)[1], 10))) - 1)
  }]

  replica_firewall_rules = [for rule in var.replica_network_rules.ip_rules : {
    start : cidrhost(rule, 0)
    end : cidrhost(rule, pow(2, (32 - parseint(split("/", rule)[1], 10))) - 1)
  }]

  private_dns_zone_name = var.private_dns_zone_id == null ? azurerm_private_dns_zone.this[0].name : var.private_dns_zone_name
  private_dns_zone_id   = var.private_dns_zone_id == null ? azurerm_private_dns_zone.this[0].id : var.private_dns_zone_id

  configuration_replica = var.enable_replica ? var.configuration_replica : {}
}

resource "azurerm_private_dns_zone" "this" {
  count = var.private_dns_zone_id == null ? 1 : 0

  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {

  name                  = format("%s-private-dns-zone-link", var.name)
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = local.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id

  tags = var.tags
}

resource "azurerm_private_endpoint" "this" {
  name                = format("%s-private-endpoint", azurerm_postgresql_server.this.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", var.name)
    private_dns_zone_ids = [local.private_dns_zone_id]
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
  count = var.enable_replica ? 1 : 0

  name                = format("%s-private-endpoint", azurerm_postgresql_server.replica[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", var.name)
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  private_service_connection {
    name                           = format("%s-private-service-connection", azurerm_postgresql_server.replica[0].name)
    private_connection_resource_id = azurerm_postgresql_server.replica[0].id
    is_manual_connection           = false
    subresource_names              = ["postgreSqlServer"]
  }

  tags = var.tags
}

resource "azurerm_postgresql_virtual_network_rule" "network_rule" {
  name                                 = format("%s-vnet-rule", var.name)
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.this.name
  subnet_id                            = var.subnet_id
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "this" {
  count = length(local.firewall_rules)

  name                = format("%s-fw-rule-%d", var.name, count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = local.firewall_rules[count.index].start
  end_ip_address      = local.firewall_rules[count.index].end
}

resource "azurerm_postgresql_firewall_rule" "azure" {
  count = var.network_rules.allow_access_to_azure_services ? 1 : 0

  name                = format("%s-allow-azure-access", var.name)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_configuration" "main" {
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
  for_each = var.monitor_metric_alert_criteria

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
  for_each = var.enable_replica ? var.replica_monitor_metric_alert_criteria : {}

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


resource "azurerm_postgresql_virtual_network_rule" "replica" {
  count = var.enable_replica ? 1 : 0

  name                                 = format("%s-rep-vnet-rule", var.name)
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.replica[0].name
  subnet_id                            = var.subnet_id
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "replica" {
  count = var.enable_replica ? length(local.replica_firewall_rules) : 0

  name                = format("%s-rep-fw-rule-%d", var.name, count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  start_ip_address    = local.replica_firewall_rules[count.index].start
  end_ip_address      = local.replica_firewall_rules[count.index].end
}

resource "azurerm_postgresql_firewall_rule" "azure_replica" {
  count = var.enable_replica && var.replica_network_rules.allow_access_to_azure_services ? 1 : 0

  name                = format("%s-rep-allow-azure-access", var.name)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.replica[0].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}


resource "azurerm_management_lock" "this" {
  count      = var.lock_enable ? 1 : 0
  name       = format("%s-lock", azurerm_postgresql_server.this.name)
  scope      = azurerm_postgresql_server.this.id
  lock_level = "CanNotDelete"
  notes      = "This items can't be deleted in this subscription!"
}

resource "null_resource" "ha_sku_check" {
  count = var.high_availability_enabled == true && length(regexall("^B_.*", var.sku_name)) > 0 ? "ERROR: High Availability is not allow for Burstable(B) series" : 0
}

resource "null_resource" "pgbouncer_check" {
  count = length(regexall("^B_.*", var.sku_name)) > 0 && var.pgbouncer_enabled ? "ERROR: PgBouncer is not allow for Burstable(B) series" : 0
}

resource "azurerm_postgresql_flexible_server" "this" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  version             = var.db_version

  #
  # Backup
  # 
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode                  = var.create_mode
  zone                         = var.zone

  #
  # Network
  #

  # The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated.
  delegated_subnet_id = var.private_endpoint_enabled ? var.delegated_subnet_id : null
  #  private_dns_zobe_id will be required when setting a delegated_subnet_id
  private_dns_zone_id = var.private_endpoint_enabled ? var.private_dns_zone_id : null

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  storage_mb = var.storage_mb
  sku_name   = var.sku_name

  dynamic "high_availability" {
    for_each = var.high_availability_enabled && var.standby_availability_zone != null ? ["dummy"] : []

    content {
      #only possible value
      mode                      = "ZoneRedundant"
      standby_availability_zone = var.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window_config != null ? ["dummy"] : []

    content {
      day_of_week  = var.maintenance_window_config.day_of_week
      start_hour   = var.maintenance_window_config.start_hour
      start_minute = var.maintenance_window_config.start_minute
    }
  }

  tags = var.tags

} # end azurerm_postgresql_flexible_server

# Configure: Enable PgBouncer
resource "azurerm_postgresql_flexible_server_configuration" "pgbouncer_enabled" {

  count = var.pgbouncer_enabled ? 1 : 0

  name      = "pgbouncer.enabled"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "True"
}

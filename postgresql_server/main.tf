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

  auto_grow_enabled = var.auto_grow_enabled

  public_network_access_enabled    = var.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

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

  auto_grow_enabled = var.auto_grow_enabled

  public_network_access_enabled    = var.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  create_mode               = var.create_mode
  creation_source_server_id = azurerm_postgresql_server.this.id

  tags = var.tags
}

resource "azurerm_private_dns_zone" "private_dns_zone_postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = format("%s-private-dns-zone-link", var.name)
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_postgres.name
  virtual_network_id    = var.virtual_network_id

  tags = var.tags
}

resource "azurerm_private_endpoint" "postgresql_private_endpoint" {
  name                = format("%s-private-endpoint", azurerm_postgresql_server.this.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", var.name)
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_postgres.id]
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
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_postgres.id]
  }

  private_service_connection {
    name                           = format("%s-private-service-connection", azurerm_postgresql_server.replica[0].name)
    private_connection_resource_id = azurerm_postgresql_server.replica[0].id
    is_manual_connection           = false
    subresource_names              = ["postgreSqlServer"]
  }

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "private_dns_a_record_postgresql" {
  name                = "postgresql"
  zone_name           = azurerm_private_dns_zone.private_dns_zone_postgres.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = azurerm_private_endpoint.postgresql_private_endpoint.private_service_connection.*.private_ip_address
}

resource "azurerm_private_dns_a_record" "replica" {
  count = var.enable_replica ? 1 : 0

  name                = "postgresql-rep"
  zone_name           = azurerm_private_dns_zone.private_dns_zone_postgres.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = azurerm_private_endpoint.replica[0].private_service_connection.*.private_ip_address
}

resource "azurerm_postgresql_virtual_network_rule" "network_rule" {
  name                                 = format("%s-vnet-rule", var.name)
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.this.name
  subnet_id                            = var.subnet_id
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_configuration" "main" {
  for_each = var.configuration

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = each.value
}

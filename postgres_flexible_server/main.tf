resource "azurerm_postgresql_flexible_server" "this" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  version             = var.db_version

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode                  = var.create_mode

  # The provided subnet should not have any other resource deployed in it and 
  # this subnet will be delegated to the PostgreSQL Flexible Server, if not
  # already delegated.
  delegated_subnet_id = var.private_endpoint.subnet_id

  #  private_dns_zobe_id will be required when setting a delegated_subnet_id
  private_dns_zone_id = var.private_endpoint.private_dns_zone.id


  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  zone                   = var.zone

  storage_mb = var.storage_mb

  sku_name = var.sku_name

  tags = var.tags

}
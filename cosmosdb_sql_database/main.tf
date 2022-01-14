resource "azurerm_cosmosdb_sql_database" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.account_name
  throughput          = var.throughput
}
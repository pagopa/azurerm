output "id" {
  description = "The id of the collection"
  value       = azurerm_cosmosdb_mongo_collection.this.id
}

output "lock_id" {
  value = var.lock_enable ? azurerm_management_lock.this[0].id : null
}

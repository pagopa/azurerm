output "id" {
  value = azurerm_postgresql_server.this.id
}

output "name" {
  value = azurerm_postgresql_server.this.name
}

output "fqdn" {
  value = azurerm_postgresql_server.this.fqdn
}

output "private_dns_zone_id" {
  value = local.private_dns_zone_id
}

output "administrator_login" {
  value = var.administrator_login
}

output "administrator_login_password" {
  value     = var.administrator_login_password
  sensitive = true
}

output "replica_id" {
  value = var.enable_replica ? azurerm_postgresql_server.replica[0].id : ""
}

output "replica_name" {
  value = var.enable_replica ? azurerm_postgresql_server.replica[0].name : ""
}

output "replica_fqdn" {
  value = var.enable_replica ? azurerm_postgresql_server.replica[0].fqdn : ""
}

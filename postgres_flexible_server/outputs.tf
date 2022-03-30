output "id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "name" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "public_access_enabled" {
  value = azurerm_postgresql_flexible_server.this.public_network_access_enabled
}

output "administrator_login" {
  value = var.administrator_login
}

output "administrator_password" {
  value     = var.administrator_password
  sensitive = true
}

output "connection_port" {
  value     = var.pgbouncer_enabled ? "6432" : "5432"
  sensitive = false
}

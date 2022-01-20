output "id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "name" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

# output "principal_id" {
#   value = azurerm_postgresql_server.this.identity.0.principal_id
# }

output "administrator_login" {
  value = var.administrator_login
}

output "administrator_login_password" {
  value     = var.administrator_login_password
  sensitive = true
}
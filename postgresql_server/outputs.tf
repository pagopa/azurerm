output "id" {
  value = azurerm_postgresql_server.this.id
}

output "name" {
  value = azurerm_postgresql_server.this.name
}

output "fqdn" {
  value = azurerm_postgresql_server.this.fqdn
}

output "administrator_login" {
  value = var.administrator_login
}

output "administrator_login_password" {
  value     = var.administrator_login_password
  sensitive = true
}
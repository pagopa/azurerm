output "id" {
  value = azurerm_api_management.this.id
}

output "name" {
  value = azurerm_api_management.this.name
}

output "private_ip_addresses" {
  value = azurerm_api_management.this.private_ip_addresses
}

output "gateway_url" {
  value = azurerm_api_management.this.gateway_url
}

output "gateway_hostname" {
  value = regex("https?://([\\d\\w\\-\\.]+)", azurerm_api_management.this.gateway_url)[0]
}

output "principal_id" {
  value = azurerm_api_management.this.identity[0].principal_id
}

output "diagnostic_id" {
  value = azurerm_api_management_diagnostic.this.id
}

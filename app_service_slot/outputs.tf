output "id" {
  value = azurerm_app_service_slot.this.id
}

output "name" {
  value = azurerm_app_service_slot.this.name
}

output "default_site_hostname" {
  value = azurerm_app_service_slot.this.default_site_hostname
}

output "principal_id" {
  value = azurerm_app_service_slot.this.identity[0].principal_id
}

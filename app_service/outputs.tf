output "name" {
  value = azurerm_app_service.this.name
}

output "plan_name" {
  value = azurerm_app_service_plan.this.name
}

output "default_site_hostname" {
  value = azurerm_app_service.this.default_site_hostname
}

output "principal_id" {
  value = azurerm_app_service.this.identity[0].principal_id
}

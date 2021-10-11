output "id" {
  value = azurerm_cdn_endpoint.this.id
}

output "hostname" {
  value = "${azurerm_cdn_endpoint.this.name}.azureedge.net"
}

output "name" {
  value = azurerm_cdn_endpoint.this.name
}
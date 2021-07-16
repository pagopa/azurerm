output "gateway_id" {
  description = "The ID of the virtual network gateway."
  value       = azurerm_virtual_network_gateway.gw.id
}

output "fqdn" {
  description = "The fqdn for gateway."
  value       = azurerm_public_ip.gw.fqdn
}

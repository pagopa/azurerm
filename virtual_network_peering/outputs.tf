output "source_id" {
  value = azurerm_virtual_network_peering.source.id
}

output "target_id" {
  value = azurerm_virtual_network_peering.target.id
}

output "source_name" {
  value = azurerm_virtual_network_peering.source.name
}

output "target_name" {
  value = azurerm_virtual_network_peering.target.name
}
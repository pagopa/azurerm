output "id" {
  value = length(var.routes) > 0 ? azurerm_route_table.this[0].id : null
}

output "subnets" {
  value = length(var.routes) > 0 ? azurerm_route_table.this[0].subnets : []
}
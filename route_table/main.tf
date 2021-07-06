
resource "azurerm_route_table" "this" {
  count                         = length(var.routes) > 0 ? 1 : 0
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "this" {
  count          = length(var.routes) > 0 ? length(var.subnet_ids) : 0
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = azurerm_route_table.this[0].id
}
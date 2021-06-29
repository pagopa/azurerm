resource "azurerm_public_ip" "this" {
  count               = var.public_ip_address_id != null ? 0 : 1
  name                = format("%s-pip", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.name
}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name                 = ip_configuration.value["name"]
      subnet_id            = ip_configuration.value["subnet_id"]
      public_ip_address_id = var.public_ip_address_id != null ? var.public_ip_address_id : azurerm_public_ip.this[0].id
    }
  }
}
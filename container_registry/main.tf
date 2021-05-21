resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled


  dynamic "georeplications" {
    for_each = var.georeplications
    iterator = g

    content {
      location = g.key
      tags     = var.tags
    }
  }
}
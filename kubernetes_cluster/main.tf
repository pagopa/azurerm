resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name               = var.node_pool_name
    node_count         = var.node_count
    vm_size            = var.vm_size
    availability_zones = var.availability_zones
  }

  dns_prefix_private_cluster = var.dns_prefix_private_cluster

  automatic_channel_upgrade       = var.automatic_channel_upgrade
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
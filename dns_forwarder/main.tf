resource "azurerm_network_profile" "this" {
  name                = format("%s-network-profile", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name

  container_network_interface {
    name = "container-nic"

    ip_configuration {
      name      = "ip-config"
      subnet_id = var.subnet_id
    }
  }
}

resource "azurerm_container_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.this.id
  os_type             = "Linux"

  container {
    name   = "dns-forwarder"
    image  = "coredns/coredns:1.8.4"
    cpu    = "0.5"
    memory = "0.5"

    commands = ["/coredns", "-conf", "/app/conf/Corefile"]

    ports {
      port     = 53
      protocol = "UDP"
    }

    volume {
      mount_path = "/app/conf"
      name       = "dns-forwarder-conf"
      read_only  = true
      secret = {
        Corefile = base64encode(data.local_file.corefile.content)
      }
    }

  }

  tags = var.tags
}

data "local_file" "corefile" {
  filename = format("%s/Corefile", path.module)
}
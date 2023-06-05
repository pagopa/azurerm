#create access ssh key
resource "tls_private_key" "this_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#store ssh public key
resource "azurerm_ssh_public_key" "this_public_key" {
  name                = "${var.name}-admin-access-key"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = tls_private_key.this_key.public_key_openssh
}

#build the image id
locals {
  source_image_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/images/${var.source_image_name}"
}

# create scale set
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_sku
  instances           = 1
  admin_username      = "adminuser"
  admin_password      = var.admin_password


  # only one of source_image_id and source_image_reference is allowed
  source_image_id = var.image_type == "custom" ? local.source_image_id : null

  dynamic "source_image_reference" {
    # only one of source_image_id and source_image_reference is allowed
    for_each = var.image_type == "standard" ? [1] : []
    content {
      publisher = var.image_reference.publisher
      offer     = var.image_reference.offer
      sku       = var.image_reference.sku
      version   = var.image_reference.version
    }
  }

  os_disk {
    storage_account_type   = var.storage_sku
    caching                = "ReadWrite"
    disk_encryption_set_id = var.encryption_set_id
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = azurerm_ssh_public_key.this_public_key.public_key
  }

  disable_password_authentication = var.authentication_type != "SSH" ? false : true

  overprovision = false

  network_interface {
    name    = "${var.name}-Nic"
    primary = true

    ip_configuration {
      name      = "${var.name}-IPc"
      primary   = true
      subnet_id = var.subnet_id
    }
  }
  platform_fault_domain_count = 1
  single_placement_group      = false
  upgrade_mode                = "Manual"

  lifecycle {
    ignore_changes = [
      # Ignore changes to these tags because they are generated by az devops.
      tags["__AzureDevOpsElasticPool"],
      tags["__AzureDevOpsElasticPoolTimeStamp"],
    ]
  }
}

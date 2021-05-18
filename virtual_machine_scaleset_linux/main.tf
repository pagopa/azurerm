resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = var.sku
  instances                       = var.instances
  admin_username                  = var.admin_username
  disable_password_authentication = true
  overprovision                   = var.overprovision
  upgrade_mode                    = var.os_upgrade_mode

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_key # file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  automatic_os_upgrade_policy {
    disable_automatic_rollback  = true
    enable_automatic_os_upgrade = true
  }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # data_disk {
  #     lun                  = data_disk.key
  #     disk_size_gb         = data_disk.value
  #     caching              = "ReadWrite"
  #     storage_account_type = var.additional_data_disks_storage_account_type
  # }

  network_interface {
    name    = format("%s-nic", var.name)
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  tags = var.tags
}

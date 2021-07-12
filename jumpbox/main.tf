resource "azurerm_public_ip" "vm_pip" {
  name                = format("%s-pip", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pip_allocation_method
}

resource "azurerm_network_security_group" "vm_sg" {
  name                = format("%s-sg", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name

  #tfsec:ignore:AZU017
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }

  #tfsec:ignore:AZU024
  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = format("%s-nic", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "vmNicConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "sg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_sg.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  size                            = var.size
  computer_name                   = var.name
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    name                 = format("%s-disk", var.name)
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  provisioner "remote-exec" {
    connection {
      host        = self.public_ip_address
      type        = "ssh"
      user        = var.admin_username
      private_key = tls_private_key.ssh_key.private_key_pem
    }

    inline = var.remote_exec_inline_commands
  }

  tags = var.tags
}

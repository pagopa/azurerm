output "ip" {
  description = "Jumpbox VM IP"
  value       = azurerm_linux_virtual_machine.jumpbox.public_ip_address
}

output "username" {
  description = "Jumpbox VM username"
  value       = var.admin_username
}

output "tls_private_key" {
  value = tls_private_key.ssh_key.private_key_pem
}
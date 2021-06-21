output "id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
  value = azurerm_kubernetes_cluster.this.private_fqdn
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw
}

output "kubelet_identity_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity.0.id
}

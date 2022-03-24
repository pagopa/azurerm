resource "null_resource" "enable_pod_identity" {
  # needs az extension
  # see https://docs.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity#before-you-begin

  count = var.enable_azure_pod_identity ? 1 : 0

  triggers = {
    resource_group_name = var.resource_group_name
    cluster_name        = azurerm_kubernetes_cluster.this.name
  }

  provisioner "local-exec" {
    command = <<EOT
      az aks update \
        -g ${self.triggers.resource_group_name} \
        -n ${self.triggers.cluster_name} \
        --enable-pod-identity
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      az aks update \
        -g ${self.triggers.resource_group_name} \
        -n ${self.triggers.cluster_name} \
        --disable-pod-identity
    EOT
  }
}


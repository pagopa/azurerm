resource "kubernetes_ingress" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/$1"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/use-regex"          = "true"
    }
  }

  spec {
    tls {
      hosts       = [var.host]
      secret_name = local.secret_name
    }

    rule {
      host = var.host
      http {
        dynamic "path" {
          for_each = var.rules

          content {
            path = path.value.path
            backend {
              service_name = path.value.service_name
              service_port = path.value.service_port
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_manifest" "this_certificates" {
  manifest = yamldecode(templatefile(
    "${path.module}/assets/tls.yaml.tpl",
    {
      namespace     = var.namespace
      secret_name   = local.secret_name
      tenant_id     = var.tenant_id
      keyvault_name = var.keyvault.name
    }
  ))
}

resource "kubernetes_manifest" "this_mounter" {
  depends_on = [kubernetes_manifest.this_certificates]

  manifest = yamldecode(templatefile(
    "${path.module}/assets/mounter.yaml.tpl",
    {
      namespace             = var.namespace
      secret_provider_class = local.secret_name
    }
  ))
}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.namespace}-ingress-pod-identity"
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = var.keyvault.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.this.principal_id

  secret_permissions = ["get"]
}

resource "null_resource" "create_pod_identity" {
  triggers = {
    resource_group = var.resource_group_name
    cluster_name   = var.cluster_name
    namespace      = var.namespace
    name           = "${var.namespace}-ingress"
    identity_id    = azurerm_user_assigned_identity.this.id
  }

  provisioner "local-exec" {
    command = <<EOT
      az aks pod-identity add \
        --resource-group ${self.triggers.resource_group} \
        --cluster-name ${self.triggers.cluster_name} \
        --namespace ${self.triggers.namespace} \
        --name "${self.triggers.namespace}-ingress-pod-identity" \
        --identity-resource-id "${self.triggers.identity_id}"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      az aks pod-identity delete \
        --resource-group ${self.triggers.resource_group} \
        --cluster-name ${self.triggers.cluster_name} \
        --namespace ${self.triggers.namespace} \
        --name ${self.triggers.name}
    EOT
  }
}


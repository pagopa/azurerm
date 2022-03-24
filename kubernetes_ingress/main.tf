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
      namespace      = var.namespace
      secret_name    = local.secret_name
      tenant_id      = var.tenant_id
      key_vault_name = var.key_vault.name
    }
  ))
}

resource "kubernetes_manifest" "this_mounter" {
  depends_on = [kubernetes_manifest.this_certificates]

  manifest = yamldecode(templatefile(
    "${path.module}/assets/mounter.yaml.tpl",
    {
      namespace             = var.namespace
      identity_name         = local.identity_name
      secret_provider_class = local.secret_name
    }
  ))
}

module "ingress_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v2.6.0"


  resource_group_name = var.resource_group_name
  location            = var.location
  identity_name       = local.identity_name
  key_vault           = var.key_vault
  tenant_id           = var.tenant_id
  cluster_name        = var.cluster_name
  namespace           = var.namespace

  secret_permissions = ["get"]
}

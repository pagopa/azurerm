# kubernetes\_ingress

Module that allows the creation of an AKS ingress.

## How to use it

```tf
module "helm-template-ingress" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_ingress?ref=k8s-ingress"

  depends_on = [
    module.nginx_ingress,
    null_resource.enable_pod_identity
  ]

  resource_group_name = format("%s-aks-rg", local.project)
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  keyvault           = data.azurerm_key_vault.kv

  name         = "ingress"
  namespace    = "helm-template"
  cluster_name = data.azurerm_kubernetes_cluster.aks_cluster.name

  host  = "helm-template.ingress.devopslab.pagopa.it"
  rules = [
    {
      path         = "/(.*)"
      service_name = "templatemicroserviziok8s-microservice-chart"
      service_port = 80
    }
  ]
}
```

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [kubernetes_ingress.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_manifest.this_certificates](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.this_mounter](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [null_resource.create_pod_identity](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_host"></a> [host](#input\_host) | Ingress host. | `string` | n/a | yes |
| <a name="input_keyvault"></a> [keyvault](#input\_keyvault) | KeyVault azurerm resource | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Ingress name. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Ingress rules. | <pre>list(object({<br>    path         = string<br>    service_name = string<br>    service_port = number<br>  }))</pre> | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant id of the KeyVault with the certificate. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

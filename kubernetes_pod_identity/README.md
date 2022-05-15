# kubernetes\_ingress

Module that allows the creation of a pod identity. Check <https://docs.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity#create-an-aks-cluster-with-kubenet-network-plugin> or <https://docs.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity#run-a-sample-application> for more information.

## Architecture

![architecture](./docs/module-arch.drawio.png)

## How to use it

```tf
module "ingress_pod_identity" {
  source = "../kubernetes_pod_identity"

  resource_group_name = "dvopla-d-aks-rg"
  location            = "northeurope"
  identity_name       = "helm-template-pod-identity"
  key_vault_id        = data.azurerm_key_vault.kv.id
  tenant_id           = "c767fb1d-a665-4714-9a1a-323a7818b016"
  cluster_name        = "dvopla-d-aks"
  namespace           = "helm-template"

  certificate_permissions = ["get"]
  key_permissions         = ["get"]
  secret_permissions      = ["get"]
}
```

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.80.0, <= 2.99.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [null_resource.create_pod_identity](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_permissions"></a> [certificate\_permissions](#input\_certificate\_permissions) | (Optional) API permissions of the identity to access certificates, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update. | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) Name of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_identity_name"></a> [identity\_name](#input\_identity\_name) | (Required) The name of the user assigned identity and POD identity. Changing this forces a new identity to be created. | `string` | n/a | yes |
| <a name="input_key_permissions"></a> [key\_permissions](#input\_key\_permissions) | (Optional) API permissions of the identity to access keys, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey. | `list(string)` | `[]` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | (Required) Specifies the id of the Key Vault resource. Changing this forces a new resource to be created. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Location of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Required) Kubernetes namespace where the pod identity will be create. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Resource group of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_secret_permissions"></a> [secret\_permissions](#input\_secret\_permissions) | (Optional) API permissions of the identity to access secrets, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set. | `list(string)` | `[]` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

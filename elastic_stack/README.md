# Elastic Stack

This module allow the creation of Elastic Stack

## Configurations

## How to use it

TODO

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.80.0, <= 2.99.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | <= 2.16.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.16.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.apm_manifest](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.elasticsearch_cluster](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.kibana_manifest](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.crd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.elastic_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.ingress_apm_manifest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.ingress_elastic_manifest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.ingress_kibana_manifest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.mounter_manifest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.operator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.secret_manifest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.eck_license](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.wait_apm](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_elasticsearch_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_kibana](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_secret.get_elastic_credential](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eck_license"></a> [eck\_license](#input\_eck\_license) | n/a | `string` | n/a | yes |
| <a name="input_elastic_agent_custom_log_config"></a> [elastic\_agent\_custom\_log\_config](#input\_elastic\_agent\_custom\_log\_config) | n/a | <pre>map(object({<br>    instance = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | Keyvault name | `string` | n/a | yes |
| <a name="input_kibana_external_domain"></a> [kibana\_external\_domain](#input\_kibana\_external\_domain) | Kibana external domain | `string` | n/a | yes |
| <a name="input_kibana_internal_hostname"></a> [kibana\_internal\_hostname](#input\_kibana\_internal\_hostname) | Kibana internal hostname | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ECK Operator | `string` | `"elastic-system"` | no |
| <a name="input_nodeset_config"></a> [nodeset\_config](#input\_nodeset\_config) | n/a | <pre>map(object({<br>    count            = string<br>    roles            = list(string)<br>    storage          = string<br>    storageClassName = string<br>  }))</pre> | <pre>{<br>  "default": {<br>    "count": 1,<br>    "roles": [<br>      "master",<br>      "data",<br>      "data_content",<br>      "data_hot",<br>      "data_warm",<br>      "data_cold",<br>      "data_frozen",<br>      "ingest",<br>      "ml",<br>      "remote_cluster_client",<br>      "transform"<br>    ],<br>    "storage": "5Gi",<br>    "storageClassName": "standard"<br>  }<br>}</pre> | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Secret certificate name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

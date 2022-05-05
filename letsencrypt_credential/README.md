# app service

This module allow the creation of an let's encrypt credentials

## Architecture

TBD

## Configurations

### Mandatory configurations

## How to use it

```ts
module "letsencrypt" {
  source =
    "git::https://github.com/pagopa/azuredevops-tf-modules.git//letsencrypt_credential?ref=v2.14.0";

  prefix = "project";
  env = "p";
  key_vault_name = "project-p-kv";
  subscription_name = "DEV-PROJECT";
}
```

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key vault where save Let's encrypt credentials | `string` | n/a | yes |
| <a name="input_le_email"></a> [le\_email](#input\_le\_email) | Let's encrypt email account | `string` | `"letsencrypt-bots@pagopa.it"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | Azure subscription name where key vault is located | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

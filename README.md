[![Static Analysis](https://github.com/pagopa/azurerm/actions/workflows/static_analysis.yml/badge.svg)](https://github.com/pagopa/azurerm/actions/workflows/static_analysis.yml)

# azurerm

Terraform Azure modules

## Precommit checks

### tfenv setup

Set the terraform version with tfenv, before launch pre-commit to avoid errors

```bash
tfenv use <x.y.x>
```

### Run pre-commit

Check your code before commit.

<https://github.com/antonbabenko/pre-commit-terraform#how-to-install>

```sh
pre-commit run -a
```

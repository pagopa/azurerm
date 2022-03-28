[![Static Analysis](https://github.com/pagopa/azurerm/actions/workflows/static_analysis.yml/badge.svg?branch=main&event=push)](https://github.com/pagopa/azurerm/actions/workflows/static_analysis.yml)

# azurerm

Terraform Azure modules

## Semantic versioning

This repo use standard semantic versioning according to https://www.conventionalcommits.org.

We use keywords in PR title to determinate next release version.

If first commit it's different from PR title you must add at least a second commit.

Due this issue https://github.com/semantic-release/commit-analyzer/issues/231 use `breaking` keyword to trigger a major change release.

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
# for terraform modules we need to initialize them with
# run this commands when there is a change in .utils/provider.tf
bash .utils/clean_all.sh
bash .utils/terraform_run_all.sh init
pre-commit run -a
```

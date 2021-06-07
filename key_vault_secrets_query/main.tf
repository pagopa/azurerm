data "azurerm_key_vault" "this" {
  name                = "io-p-kv-azuredevops"
  resource_group_name = "io-p-rg-operations"
}

data "azurerm_key_vault_secret" "this" {
  for_each     = toset(var.secrets)
  name         = each.value
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group
}

data "azurerm_key_vault_secret" "this" {
  for_each     = toset(var.secrets)
  name         = each.value
  key_vault_id = data.azurerm_key_vault.this.id
}

output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.this.name
}

output "id" {
  value = azurerm_eventhub.eventhub[*].id
}

output "names" {
  value = azurerm_eventhub.eventhub[*].name
}

output "rule_ids" {
  value = azurerm_eventhub_authorization_rule.eventhub_rule[*].id
}

output "rule_names" {
  value = azurerm_eventhub_authorization_rule.eventhub_rule[*].name
}
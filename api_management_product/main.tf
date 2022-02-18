resource "azurerm_api_management_product" "this" {
  product_id          = var.product_id
  api_management_name = var.api_management_name
  display_name        = var.display_name
  description         = var.description

  subscription_required = var.subscription_required
  subscriptions_limit   = var.subscriptions_limit
  approval_required     = var.approval_required
  published             = var.published

  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_product_policy" "this" {
  count = var.policy_xml == null ? 0 : 1

  product_id          = azurerm_api_management_product.this.product_id
  api_management_name = var.api_management_name

  xml_content = var.policy_xml

  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_product_group" "this" {
  for_each = var.groups

  product_id          = azurerm_api_management_product.this.product_id
  api_management_name = var.api_management_name
  group_name          = each.key

  resource_group_name = var.resource_group_name
}

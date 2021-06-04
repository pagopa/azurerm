
resource "azurerm_api_management_api" "this" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  revision              = var.revision
  display_name          = var.display_name
  description           = var.description
  path                  = var.path
  protocols             = var.protocols
  service_url           = var.service_url
  subscription_required = var.subscription_required

  import {
    content_format = var.content_format
    content_value  = var.content_value
  }

}


resource "azurerm_api_management_api_policy" "this" {
  api_name            = azurerm_api_management_api.this.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  xml_content = var.xml_content
}

resource "azurerm_api_management_product_api" "this" {
  for_each = toset(var.product_ids)

  product_id          = each.value
  api_name            = azurerm_api_management_api.this.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_api_operation_policy" "api_operation_policy" {
  count = length(var.api_operation_policies)

  api_name            = azurerm_api_management_api.this.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  operation_id        = var.api_operation_policies[count.index].operation_id

  xml_content = var.api_operation_policies[count.index].xml_content
}
resource "azurerm_data_factory" "df" {
  name                   = format("%s-%s-data-factory", var.name_prefix, var.name)
  location               = var.location
  resource_group_name    = var.resource_group_name
  public_network_enabled = false

  github_configuration {
    # (Required) Specifies the GitHub account name
    account_name    = var.github_conf.account_name 
    # (Required) Specifies the collaboration branch of the repository to get code from.
    # The poublish branch is automatically set to adf_publish
    branch_name     = var.github_conf.branch_name 
    # (Required) Specifies the GitHub Enterprise host name. 
    # For example: https://github.mydomain.com. Use https://github.com for open source repositories
    git_url         = var.github_conf.git_url
    # (Required) Specifies the name of the git repository
    repository_name = var.github_conf.repository_name
    # (Required) Specifies the root folder within the repository. Set to / for the top level.
    root_folder     = var.github_conf.root
  }

  # Still doesn't work: https://github.com/hashicorp/terraform-provider-azurerm/issues/12949
  managed_virtual_network_enabled = true 

}

resource "azurerm_private_endpoint" "pe" {
  name                = format("%s-%s-private-endpoint", var.name_prefix, var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name = format("%s-%s-private-dns-zone-group", var.name_prefix, var.name)
    # One of the concatenated arrays is empty
    private_dns_zone_ids = [var.private_dns_zone.id]
  }

  private_service_connection {
    name                           = format("%s-%s-private-service-connection", var.name_prefix, var.name)
    private_connection_resource_id = azurerm_data_factory.df.id
    is_manual_connection           = false
    subresource_names              = ["datafactory"]
  }
}

resource "azurerm_private_dns_a_record" "record" {
  name                = var.name
  zone_name           = var.private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = azurerm_private_endpoint.pe.private_service_connection.*.private_ip_address
}

resource "azurerm_data_factory_managed_private_endpoint" "mpe" {
  foreach = var.resources_managed_private_enpoint
  name               = replace(format("%s-%s-%s-mng-private-endpoint", var.name_prefix, var.name, each.key.name), "-", "_")
  data_factory_id    = azurerm_data_factory.df.id
  target_resource_id = each.key.id
  subresource_name   = each.key.name
}


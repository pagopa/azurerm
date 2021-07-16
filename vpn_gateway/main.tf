#
# Gateway
#

resource "random_string" "dns" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_public_ip" "gw" {
  name                = "${var.name}-gw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  domain_name_label = format("%sgw%s", lower(replace(var.name, "/[[:^alnum:]]/", "")), random_string.dns.result)
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "gw_pip" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "gw-pip-log-analytics"
  target_resource_id         = azurerm_public_ip.gw.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "DDoSProtectionNotifications"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DDoSMitigationFlowLogs"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DDoSMitigationReports"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_virtual_network_gateway" "gw" {
  name                = "${var.name}-gw"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku

  ip_configuration {
    name                          = "${var.name}-gw-config"
    public_ip_address_id          = azurerm_public_ip.gw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  dynamic "vpn_client_configuration" {
    for_each = var.client_configuration != null ? [var.client_configuration] : []
    iterator = vpn
    content {
      address_space = [vpn.value.address_space]

      root_certificate {
        name = "VPN-Certificate"

        public_cert_data = vpn.value.certificate
      }

      vpn_client_protocols = vpn.value.protocols
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "gw" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "gw-analytics"
  target_resource_id         = azurerm_virtual_network_gateway.gw.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "GatewayDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "TunnelDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "RouteDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "IKEDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "P2SDiagnosticLog"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_local_network_gateway" "local" {
  count               = length(var.local_networks)
  name                = "${var.local_networks[count.index].name}-lng"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.local_networks[count.index].gateway_address
  address_space       = var.local_networks[count.index].address_space

  tags = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "local" {
  count               = length(var.local_networks)
  name                = "${var.local_networks[count.index].name}-lngc"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.local[count.index].id

  shared_key = var.local_networks[count.index].shared_key

  dynamic "ipsec_policy" {
    for_each = var.local_networks[count.index].ipsec_policy != null ? [true] : []
    content {
      dh_group         = var.local_networks[count.index].ipsec_policy.dh_group
      ike_encryption   = var.local_networks[count.index].ipsec_policy.ike_encryption
      ike_integrity    = var.local_networks[count.index].ipsec_policy.ike_integrity
      ipsec_encryption = var.local_networks[count.index].ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.local_networks[count.index].ipsec_policy.ipsec_integrity
      pfs_group        = var.local_networks[count.index].ipsec_policy.pfs_group
      sa_datasize      = var.local_networks[count.index].ipsec_policy.sa_datasize
      sa_lifetime      = var.local_networks[count.index].ipsec_policy.sa_lifetime
    }
  }

  tags = var.tags
}


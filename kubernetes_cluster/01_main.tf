# https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
resource "null_resource" "pgbouncer_check" {
  count = length(regexall("^B_.*", var.system_node_pool_vm_size)) > 0 && var.system_node_pool_os_disk_type == "Ephemeral" ? "ERROR: Burstable(B) series don't allow Ephemeral disks" : 0
}


#tfsec:ignore:AZU008
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  private_cluster_enabled = var.private_cluster_enabled

  #
  # System node pool
  #
  default_node_pool {
    name = var.system_node_pool_name

    ### vm configuration
    vm_size                      = var.system_node_pool_vm_size
    # https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general
    os_disk_type                 = var.system_node_pool_os_disk_type # Managed or Ephemeral
    os_disk_size_gb              = var.system_node_pool_os_disk_size_gb
    type                         = "VirtualMachineScaleSets"
    only_critical_addons_enabled = var.system_node_pool_only_critical_addons_enabled
    availability_zones           = ["1", "2", "3"]
    ultra_ssd_enabled            = var.system_node_pool_ultra_ssd_enabled
    enable_host_encryption       = var.system_node_pool_enable_host_encryption

    ### autoscaling
    enable_auto_scaling = true
    node_count          = var.system_node_pool_node_count_min
    min_count           = var.system_node_pool_node_count_min
    max_count           = var.system_node_pool_node_count_max

    ### K8s node configuration
    max_pods    = var.system_node_pool_max_pods
    node_labels = var.system_node_pool_node_labels

    ### networking
    vnet_subnet_id        = var.vnet_subnet_id
    enable_node_public_ip = false

    upgrade_settings {
      max_surge = var.upgrade_settings_max_surge
    }

    tags = merge(var.tags, var.system_node_pool_tags)
  }

  automatic_channel_upgrade       = var.automatic_channel_upgrade
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges #tfsec:ignore:AZU008

  # managed identity type: https://docs.microsoft.com/en-us/azure/aks/use-managed-identity
  identity {
    type = "SystemAssigned"
  }

  dynamic "network_profile" {
    for_each = var.network_profile != null ? [var.network_profile] : []
    iterator = p
    content {
      docker_bridge_cidr = p.value.docker_bridge_cidr
      dns_service_ip     = p.value.dns_service_ip
      network_policy     = p.value.network_policy
      network_plugin     = p.value.network_plugin
      outbound_type      = p.value.outbound_type
      service_cidr       = p.value.service_cidr
      load_balancer_sku  = "Standard"
      load_balancer_profile {
        outbound_ip_address_ids = var.outbound_ip_address_ids
      }
    }
  }

  role_based_access_control {
    enabled = var.rbac_enabled
    azure_active_directory {
      managed                = true
      admin_group_object_ids = var.aad_admin_group_ids
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.log_analytics_workspace_id != null ? true : false #tfsec:ignore:AZU009
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
    aci_connector_linux {
      enabled = false
    }
    azure_policy {
      enabled = var.addon_azure_policy_enabled
    }
    azure_keyvault_secrets_provider {
      enabled                 = var.addon_azure_keyvault_secrets_provider_enabled
      secret_rotation_enabled = true
    }
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }

  tags = var.tags
}

#
# Role Assigments
#
resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.this.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}

resource "azurerm_role_assignment" "vnet_role" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "vnet_outbound_role" {
  for_each = toset(var.outbound_ip_address_ids)

  scope                = each.key
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

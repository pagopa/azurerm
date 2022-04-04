variable "name" {
  type        = string
  description = "Cluster name"
}

variable "dns_prefix" {
  type        = string
  description = "Dns prefix."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type = string
}

variable "aad_admin_group_ids" {
  description = "IDs of the Azure AD group for cluster-admin access"
  type        = list(string)
}

variable "node_pool_name" {
  type        = string
  default     = "default"
  description = "The name which should be used for the default Kubernetes Node Pool."
}

variable "vm_size" {
  type        = string
  description = "(Required) The size of the Virtual Machine, such as Standard_B4ms or Standard_D4s_vX. See https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/134840344/Best+practice+su+prodotti"
}

variable "sku_tier" {
  type        = string
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)"
  default     = "Free"
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster."
  default     = null
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = []
}

variable "private_cluster_enabled" {
  type        = bool
  default     = false
  description = "Provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located."
}

variable "vnet_id" {
  type        = string
  description = "Virtual network id, where the k8s cluster is deployed."
}

variable "vnet_subnet_id" {
  type        = string
  description = "The ID of a Subnet where the Kubernetes Node Pool should exist."
  default     = null
}

variable "dns_prefix_private_cluster" {
  type        = string
  description = "Specifies the DNS prefix to use with private clusters. Changing this forces a new resource to be created."
  default     = null
}

variable "automatic_channel_upgrade" {
  type        = string
  description = "The upgrade channel for this Kubernetes Cluster"
  default     = null
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "The IP ranges to whitelist for incoming traffic to the masters."
  default     = []
}

variable "network_profile" {
  type = object({
    docker_bridge_cidr = string # e.g. '172.17.0.1/16'
    dns_service_ip     = string # e.g. '10.2.0.10'. IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)
    network_policy     = string # e.g. 'azure'. Sets up network policy to be used with Azure CNI. Currently supported values are calico and azure.
    network_plugin     = string # e.g. 'azure'. Network plugin to use for networking. Currently supported values are azure and kubenet
    outbound_type      = string # e.g. 'loadBalancer'. The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway. Defaults to loadBalancer
    service_cidr       = string # e.g. '10.2.0.0/16'. The Network Range used by the Kubernetes service
  })
  default = {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_policy     = "azure"
    network_plugin     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/16"
  }
  description = "See variable description to understand how to use it, and see examples"
}

variable "outbound_ip_address_ids" {
  type        = list(string)
  default     = []
  description = "The ID of the Public IP Addresses which should be used for outbound communication for the cluster load balancer."
}

# Autoscaling

variable "node_count" {
  type        = number
  description = "The initial number of nodes which should exist in this Node Pool."
  default     = 1
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool? "
  default     = false
}

variable "enable_azure_policy" {
  type        = bool
  description = "Should the Azure Policy addon be enabled for this Node Pool? "
  default     = false
}

variable "enable_azure_keyvault_secrets_provider" {
  type        = bool
  description = "Should the Azure Secrets Store CSI addon be enabled for this Node Pool? "
  default     = false
}

variable "enable_azure_pod_identity" {
  type        = bool
  description = "Should the AAD pod-managed identities be enabled for this Node Pool? "
  default     = false
}

variable "min_count" {
  type        = number
  description = "The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = null
}

variable "max_count" {
  type        = number
  description = "The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = null
}

variable "max_pods" {
  type        = number
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = 30
}

variable "upgrade_settings_max_surge" {
  type        = string
  description = "The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade."
  default     = "33%"
}

# Logs
variable "log_analytics_workspace_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace which the OMS Agent should send data to."
  default     = null
}

# Kubernetes RBAC
variable "rbac_enabled" {
  type        = bool
  description = "Is Role Based Access Control Enabled?"
  default     = true
}

variable "metric_alerts" {
  default = {}

  description = <<EOD
Map of name = criteria objects
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
    # "Insights.Container/pods" "Insights.Container/nodes"
    metric_namespace = string
    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
    operator  = string
    threshold = number
    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H
    frequency = string
    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.
    window_size = string

    dimension = list(object(
      {
        name     = string
        operator = string
        values   = list(string)
      }
    ))
  }))
}

variable "action" {
  description = "The ID of the Action Group and optional map of custom string properties to include with the post webhook operation."
  type = set(object(
    {
      action_group_id    = string
      webhook_properties = map(string)
    }
  ))
  default = []
}

variable "alerts_enabled" {
  type        = bool
  default     = true
  description = "Should Metrics Alert be enabled?"
}

variable "sec_log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Log analytics workspace security (it should be in a different subscription)."
}

variable "sec_storage_id" {
  type        = string
  default     = null
  description = "Storage Account security (it should be in a different subscription)."
}

variable "tags" {
  type = map(any)
}

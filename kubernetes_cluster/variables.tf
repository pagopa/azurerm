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

variable "aad_admin_group_id" {
  description = "ID of the Azure AD group for cluster-admin access"
  type        = string
}

variable "node_pool_name" {
  type        = string
  default     = "default"
  description = "The name which should be used for the default Kubernetes Node Pool."
}

variable "vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "The size of the Virtual Machine"
}

variable "kubernetes_version" {
  type        = string
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
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
    docker_bridge_cidr = string
    dns_service_ip     = string
    network_policy     = string
    network_plugin     = string
    outbound_type      = string
    service_cidr       = string
  })
  default = null
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

    dimension = map(object({
      name     = string
      operator = string
      values   = list(string)
    }))
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

variable "tags" {
  type = map(any)
}

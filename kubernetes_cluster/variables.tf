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
    network_plugin     = string
    outbound_type      = string
    service_cidr       = string
  })
  default = null
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

variable "tags" {
  type = map(any)
}
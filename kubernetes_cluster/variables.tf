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

variable "node_count" {
  type        = number
  description = "The initial number of nodes which should exist in this Node Pool."
  default     = 1

}

variable "availability_zones" {
  type        = list(string)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = []
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
  type        = string
  description = "The IP ranges to whitelist for incoming traffic to the masters."
  default     = null
}

variable "log_analytics_workspace_name" {
  type    = string
  default = null
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable "log_analytics_workspace_location" {
  type    = string
  default = null
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "tags" {
  type = map(any)
}
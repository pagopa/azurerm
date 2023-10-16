variable "location" {
  type = string
}

variable "source_resource_group_name" {
  type        = string
  description = "The name of the resource group in which to start the virtual network peering"
}

variable "target_resource_group_name" {
  type        = string
  description = "The name of the resource group in which to end the virtual network peering"
  default     = null
}

variable "source_virtual_network_name" {
  type        = string
  description = "The name of the virtual network from which the peering starts"
}

variable "target_virtual_network_name" {
  type        = string
  description = "The name of the virtual network from which the peering ends"
}

variable "source_remote_virtual_network_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network from which the peering starts."
}

variable "target_remote_virtual_network_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network from which the peering ends."
}

variable "source_allow_virtual_network_access" {
  type        = bool
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network."
  default     = true
}

variable "target_allow_virtual_network_access" {
  type        = bool
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network."
  default     = true
}

variable "source_allow_forwarded_traffic" {
  type        = bool
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
  default     = false
}

variable "target_allow_forwarded_traffic" {
  type        = bool
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
  default     = false
}

variable "source_allow_gateway_transit" {
  type        = bool
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network."
  default     = false
}

variable "target_allow_gateway_transit" {
  type        = bool
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network."
  default     = false
}

variable "source_use_remote_gateways" {
  type        = bool
  description = "Controls if remote gateways can be used on the local virtual network"
  default     = false
}

variable "target_use_remote_gateways" {
  type        = bool
  description = "Controls if remote gateways can be used on the local virtual network"
  default     = false
}

variable "source_peering_custom_name" {
  type        = string
  description = "Source Peering custom name, to allow to not recreate the peering"
  default     = ""
}

variable "target_peering_custom_name" {
  type        = string
  description = "Target Peering custom name, to allow to not recreate the peering"
  default     = ""
}

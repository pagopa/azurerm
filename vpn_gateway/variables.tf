variable "name" {
  description = "Name of virtual gateway."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "The Azure Region in which to create resource."
}

variable "subnet_id" {
  description = "Id of subnet where gateway should be deployed, have to be names GatewaySubnet."
}

variable "enable_bgp" {
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false."
  type        = bool
  default     = false
}

variable "active_active" {
  description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false."
  type        = bool
  default     = false
}

variable "generation" {
  type        = string
  description = "The Generation of the Virtual Network gateway"
  default     = null
}

variable "sku" {
  description = "Configuration of the size and capacity of the virtual network gateway."
}

variable "vpn_client_configuration" {
  description = "If set it will activate point-to-site configuration."
  type = list(object(
    {
      aad_audience          = string
      aad_issuer            = string
      aad_tenant            = string
      address_space         = list(string)
      radius_server_address = string
      radius_server_secret  = string
      revoked_certificate = list(object(
        {
          name       = string
          thumbprint = string
        }
      ))
      root_certificate = list(object(
        {
          name             = string
          public_cert_data = string
        }
      ))
      vpn_client_protocols = list(string)
    }
  ))
  default = []
}

variable "local_networks" {
  description = "List of local virtual network connections to connect to gateway."
  type        = list(object({ name = string, gateway_address = string, address_space = list(string), shared_key = string, ipsec_policy = any }))
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

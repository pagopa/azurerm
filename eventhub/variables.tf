variable "name" {
  type        = string
  description = "Eventhub namespace description."
}

variable "location" {
  type = string
}

// Resource Group 
variable "resource_group_name" {
  type = string
}

variable "auto_inflate_enabled" {
  type        = bool
  description = "Is Auto Inflate enabled for the EventHub Namespace?"
  default     = false
}

variable "eventhubs" {
  description = "A list of event hubs to add to namespace."
  type = list(object({
    name              = string
    partitions        = number
    message_retention = number
    consumers         = list(string)
    keys = list(object({
      name   = string
      listen = bool
      send   = bool
      manage = bool
    }))
  }))
  default = []
}

variable "sku" {
  type        = string
  description = "Defines which tier to use. Valid options are Basic and Standard."
}

variable "capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace."
  default     = null
}

variable "maximum_throughput_units" {
  type        = number
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled"
  default     = null
}

variable "network_rulesets" {
  type = list(object({
    default_action = string
    virtual_network_rule = list(object({
      subnet_id                                       = string
      ignore_missing_virtual_network_service_endpoint = bool
    }))
    ip_rule = list(object({
      ip_mask = string
      action  = string
    }))
  }))
  default = []
}

variable "zone_redundant" {
  type        = bool
  default     = false
  description = "Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones)."
}

variable "tags" {
  type = map(any)
}

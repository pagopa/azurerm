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

variable "virtual_network_id" {
  type        = string
  description = "The ID of the Virtual Network that should be linked to the DNS Zone."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The id of the subnet that will be used for the eventhub."
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


variable "metric_alerts" {
  default = {}

  description = <<EOD
Map of name = criteria objects
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
    description = string
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

variable "tags" {
  type = map(any)
}

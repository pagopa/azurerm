variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type        = string
  description = "(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  default     = "Basic"
}

variable "zone_redundancy_enabled" {
  type        = string
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "admin_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "anonymous_pull_enabled" {
  type        = bool
  description = "(Optional) Whether allows anonymous (unauthenticated) pull access to this Container Registry? Defaults to false. This is only supported on resources with the Standard or Premium SKU."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to true."
  default     = true
}

variable "network_rule_bypass_option" {
  type        = string
  description = "(Optional) Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. Defaults to AzureServices."
  default     = "AzureServices"
}

variable "georeplications" {
  type = list(object({
    location                  = string
    regional_endpoint_enabled = bool
    zone_redundancy_enabled   = bool
  }))
  description = "A list of Azure locations where the container registry should be geo-replicated."
  default     = []
}

variable "private_endpoint" {
  type = object({
    enabled              = bool
    virtual_network_id   = string
    subnet_id            = string
    private_dns_zone_ids = list(string)
  })
  description = "(Required) Enable private endpoint with required params"
}

# Not ready for multi region
# variable "private_endpoint_georeplications" {
#   type = list(object({
#     enabled              = bool
#     location             = string
#     resource_group_name  = string
#     virtual_network_id   = string
#     subnet_id            = string
#     private_dns_zone_ids = list(string)
#   }))
#   description = "(Required) Enable private endpoint with required params"
#   default = []
# }

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

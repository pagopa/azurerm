variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "function_app_name" {
  type        = string
  description = "Name of the function app. (The production slot)"
}


variable "resource_group_name" {
  type = string
}

variable "runtime_version" {
  type    = string
  default = "~3"
}

variable "app_service_plan_id" {
  type        = string
  description = "The app service plan id to associate to the function."
  default     = null
}

variable "pre_warmed_instance_count" {
  type    = number
  default = 1
}

variable "application_insights_instrumentation_key" {
  type = string
}

variable "app_settings" {
  type    = map(any)
  default = {}
}

variable "allowed_ips" {
  type        = list(string)
  default     = []
  description = "Ip from wich is allowed to call the function. An empty list means from everywhere."
}

variable "cors" {
  type = object({
    allowed_origins = list(string)
  })
  default = null
}

variable "allowed_subnets" {
  type        = list(string)
  default     = []
  description = "List of subnet ids which are allowed to call the function. An empty list means from each subnet."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)"
}


variable "storage_account_name" {
  type        = string
  description = "Storage account in use by the functio."
}

variable "storage_account_access_key" {
  type        = string
  description = "Access key of the sorege account used by the function."
  default     = null
}

variable "durable_function_storage_connection_string" {
  type        = string
  description = "Storage account connection string for durable functions. Null in case of standard function"

}

variable "app_service_plan_sku" {
  type        = string
  description = "App service plan sku"
}

variable "auto_swap_slot_name" {
  type        = string
  description = "The name of the slot to automatically swap to during deployment"
  default     = null
}

variable "health_check_path" {
  type        = string
  default     = null
  description = "Path which will be checked for this function app health."
}

variable "health_check_maxpingfailures" {
  type    = number
  default = 10
}

variable "export_keys" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(any)
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Service and App Service Plan."
}

## App service

variable "app_service_plan_id" {
  type        = string
  description = "(Required) The ID of the App Service Plan within which to create this App Service Slot. Changing this forces a new resource to be created."
}

variable "app_service_id" {
  type        = string
  description = "(Required) The id of the App Service within which to create the App Service Slot."
}

variable "app_service_name" {
  type        = string
  description = "(Required) The name of the App Service within which to create the App Service Slot. Changing this forces a new resource to be created."
}

## App service slot

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the App Service. Changing this forces a new resource to be created."
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "always_on" {
  type        = bool
  description = "(Optional) Should the app be loaded at all times? Defaults to false."
  default     = false
}

# Ex. for linux "NODE|10-lts"
variable "linux_fx_version" {
  type        = string
  description = "(Optional) Linux App Framework and version for the App Service."
  default     = null
}

variable "app_command_line" {
  type        = string
  description = "(Optional) App command line to launch, e.g. /sbin/myserver -b 0.0.0.0."
  default     = null
}

variable "ftps_state" {
  type        = string
  description = "(Optional) Enable FTPS connection ( Default: Disabled )"
  default     = "Disabled"
}

variable "health_check_path" {
  type        = string
  description = "(Optional) The health check path to be pinged by App Service."
  default     = null
}

variable "allowed_subnets" {
  type        = list(string)
  description = "(Optional) List of subnet allowed to call the appserver endpoint."
  default     = []
}

variable "allowed_ips" {
  type        = list(string)
  description = "(Optional) List of ips allowed to call the appserver endpoint."
  default     = []
}

variable "vnet_integration" {
  type        = bool
  description = "(optional) enable vnet integration. Wheter it's true the subnet_id should not be null."
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "(Optional) Subnet id wether you want to integrate the app service to a subnet."
  default     = null
}

variable "vnet_route_all_enabled" {
  type        = bool
  description = "Should all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied?"
  default     = true
}

variable "tags" {
  type = map(any)
}

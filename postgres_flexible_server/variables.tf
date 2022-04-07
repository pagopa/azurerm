variable "name" {
  type        = string
  description = "(Required) The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the PostgreSQL Flexible Server should exist."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the PostgreSQL Flexible Server should exist."
}

variable "db_version" {
  type        = number
  description = "(Required) The version of PostgreSQL Flexible Server to use. Possible values are 11,12 and 13. Required when create_mode is Default"
}

#
# Network
#

variable "private_endpoint_enabled" {
  type        = bool
  description = "Is this instance private only?"
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the private dns zone to create the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "delegated_subnet_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated."
}

#
# ♊️ High Availability
#
variable "high_availability_enabled" {
  type        = bool
  description = "(Required) Is the High Availability Enabled"
}

variable "standby_availability_zone" {
  type        = number
  default     = null
  description = "(Optional) Specifies the Availability Zone in which the standby Flexible Server should be located."
}

variable "maintenance_window_config" {
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  })

  default = {
    day_of_week  = 3
    start_hour   = 2
    start_minute = 0
  }

  description = "(Optional) Allows the configuration of the maintenance window, if not configured default is Wednesday@2.00am"

}

#
# Administration
#
variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Flexible Server. Required when create_mode is Default."
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login for the PostgreSQL Flexible Server. Required when create_mode is Default."
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)."
}

variable "storage_mb" {
  type        = number
  description = "The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216, and 33554432."
  default     = null
}

#
# Backup
#

variable "backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. Defaults to false"
  default     = false
}

variable "create_mode" {
  type        = string
  description = "(Optional) The creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore"
  default     = "Default"
}

variable "zone" {
  type        = number
  description = "(Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located."
  default     = 1
}

#
# DB Configurations
#
variable "pgbouncer_enabled" {
  type        = bool
  default     = true
  description = "Is PgBouncer enabled into configurations?"
}

#
# Monitoring & Alert
#
variable "diagnostic_settings_enabled" {
  type = bool
  default = true
  description = "Is diagnostic settings enabled?"
}

variable "tags" {
  type = map(any)
}

locals {
  high_availability_zone = var.zone != null && var.zone == 2 ? 3 : 1
}

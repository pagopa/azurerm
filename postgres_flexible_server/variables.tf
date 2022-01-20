variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "private_endpoint" {
  description = "Enable private endpoint with required params"
  type = object({
    enabled   = bool
    subnet_id = string
    private_dns_zone = object({
      id   = string
      name = string
      rg   = string
    })
  })
}

variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Server."
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login for the PostgreSQL Server."
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server. "
}

variable "db_version" {
  type        = number
  description = "Specifies the version of PostgreSQL to use."
}

variable "storage_mb" {
  type        = number
  description = "Server Storage"
  default     = null
}

variable "zone" {
  type        = number
  description = "DBMS zone"
  default     = 1
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the server"
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Turn Geo-redundant server backups on/off."
  default     = false
}

variable "create_mode" {
  type        = string
  description = "The creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore"
  default     = "Default"
}

variable "tags" {
  type = map(any)
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

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
  description = "The id of the subnet that will be used to deploy the database."
}

variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Server."
}

variable "administrator_login_password" {
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
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. "
  default     = 5120
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this server."
  default     = true
}

variable "ssl_enforcement_enabled" {
  type        = bool
  description = "Specifies if SSL should be enforced on connections."
  default     = true
}

variable "ssl_minimal_tls_version_enforced" {
  type        = string
  description = "The mimimun TLS version to support on the sever"
  default     = "TLSEnforcementDisabled"
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the server, supported values are between"
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Turn Geo-redundant server backups on/off."
  default     = false
}

variable "enable_replica" {
  type        = bool
  description = "Create a replica server"
  default     = false
}

variable "create_mode" {
  type        = string
  description = "The creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore"
  default     = "Default"
}

variable "creation_source_server_id" {
  type        = string
  description = "For creation modes other then default the source server ID to use."
  default     = null
}

variable "restore_point_in_time" {
  type        = string
  description = "When create_mode is PointInTimeRestore the point in time to restore from creation_source_server_id."
  default     = null
}
variable "configuration" {
  description = "Map with PostgreSQL configurations."
  type        = map(string)
  default     = {}
}

variable "tags" {
  type = map(any)
}

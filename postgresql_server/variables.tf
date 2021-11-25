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
  type = object({
    enabled              = bool
    virtual_network_id   = string
    subnet_id            = string
    private_dns_zone_ids = list(string)
  })
  description = "(Required) Enable vnet private endpoint with required params"
}

variable "network_rules" {
  description = "Network rules restricting access to the postgresql server."
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules                       = []
    allow_access_to_azure_services = false
  }
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this server."
  default     = false
}

variable "allowed_subnets" {
  type        = list(string)
  description = "(Optional) Allowed subnets ids"
  default     = []
}

variable "replica_allowed_subnets" {
  type        = list(string)
  description = "(Optional) Allowed subnets ids"
  default     = []
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
  default     = null
}

variable "ssl_enforcement_enabled" {
  type        = bool
  description = "Specifies if SSL should be enforced on connections."
  default     = true
}

variable "ssl_minimal_tls_version_enforced" {
  type        = string
  description = "The mimimun TLS version to support on the sever"
  default     = "TLS1_2"
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

variable "configuration_replica" {
  description = "Map with PostgreSQL configurations."
  type        = map(string)
  default     = {}
}

variable "alerts_enabled" {
  type        = bool
  default     = true
  description = "Should Metric Alerts be enabled?"
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

variable "monitor_metric_alert_criteria" {
  default = {}

  description = <<EOD
Map of name = criteria objects, see these docs for options
https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported#microsoftdbforpostgresqlservers
https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits#maximum-connections
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
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

variable "replica_monitor_metric_alert_criteria" {
  default = {}

  description = <<EOD
Map of name = criteria objects, see these docs for options
https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported#microsoftdbforpostgresqlservers
https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits#maximum-connections
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
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

variable "replica_action" {
  description = "The ID of the Action Group and optional map of custom string properties to include with the post webhook operation."
  type = set(object(
    {
      action_group_id    = string
      webhook_properties = map(string)
    }
  ))
  default = []
}

variable "replica_network_rules" {
  description = "Network rules restricting access to the replica postgresql server."
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules                       = []
    allow_access_to_azure_services = false
  }
}

variable "lock_enable" {
  type        = bool
  default     = false
  description = "Apply lock to block accedentaly deletions."
}

variable "tags" {
  type = map(any)
}

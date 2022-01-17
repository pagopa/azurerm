variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name. If null it will be 'computed'"
  default     = null
}

variable "storage_account_durable_name" {
  type        = string
  description = "Storage account name only used by the durable function. If null it will be 'computed'"
  default     = null
}

variable "app_service_plan_name" {
  type        = string
  description = "Name of the app service plan. If null it will be 'computed'"
  default     = null
}

variable "resource_group_name" {
  type = string
}

variable "runtime_version" {
  type    = string
  default = "~3"
}

variable "storage_account_info" {
  type = object({
    account_tier                      = string
    account_replication_type          = string
    access_tier                       = string
    advanced_threat_protection_enable = bool
  })

  default = {
    account_tier                      = "Standard"
    account_replication_type          = "LRS"
    access_tier                       = "Hot"
    advanced_threat_protection_enable = true
  }
}

variable "app_service_plan_id" {
  type        = string
  description = "The app service plan id to associate to the function. If null a new plan is created, if not null the app_service_plan_info is not relevant."
  default     = null
}

variable "app_service_plan_info" {
  type = object({
    kind                         = string
    sku_tier                     = string
    sku_size                     = string
    maximum_elastic_worker_count = number
  })

  default = {
    kind                         = "elastic"
    sku_tier                     = "ElasticPremium"
    sku_size                     = "EP1"
    maximum_elastic_worker_count = 1
  }
}

variable "pre_warmed_instance_count" {
  type    = number
  default = 1
}

variable "always_on" {
  type        = bool
  description = "(Optional) Should the app be loaded at all times? Defaults to false."
  default     = false
}

variable "application_insights_instrumentation_key" {
  type = string
}

variable "app_settings" {
  type    = map(any)
  default = {}
}

variable "os_type" {
  type        = string
  description = "(Optional) App service os type. For Linux app service plan set with linux"
  default     = null
}

variable "allowed_ips" {
  // List of ip
  type    = list(string)
  default = []
}

variable "cors" {
  type = object({
    allowed_origins = list(string)
  })
  default = null
}

variable "allowed_subnets" {
  // List of subnet id
  type    = list(string)
  default = []
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)"
}

variable "internal_storage" {
  type = object({
    enable                     = bool
    private_endpoint_subnet_id = string
    private_dns_zone_blob_ids  = list(string)
    private_dns_zone_queue_ids = list(string)
    private_dns_zone_table_ids = list(string)
    queues                     = list(string)
    containers                 = list(string)
    blobs_retention_days       = number
  })

  default = {
    enable                     = false
    private_endpoint_subnet_id = "dummy"
    private_dns_zone_blob_ids  = []
    private_dns_zone_queue_ids = []
    private_dns_zone_table_ids = []
    queues                     = []
    containers                 = []
    blobs_retention_days       = 1
  }
}

variable "health_check_path" {
  type        = string
  description = "Path which will be checked for this function app health."
  default     = null

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
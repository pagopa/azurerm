## REQUIRED

variable "location" {
  type        = string
  description = "(Required) Specifies the location where this module will create the resources."
}

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Function App. Changing this forces a new resource to be created. Please do not specifies the suffix (the '-fn' suffix will be added by this module)."
}

variable "application_insights_instrumentation_key" {
  type        = string
  description = "(Required) Application insights instrumentation key"
}

variable "vnet_resource_group" {
  type        = string
  description = "(Required) The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)"
}

variable "vnet_name" {
  type        = string
  description = "(Required) The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)"
}

variable "cidr_subnet_app" {
  type        = list(string)
  description = "(Required) Function app address space."
}

variable "azdoa_snet_id" {
  type        = string
  description = "(Required) Azure devops agent subnet id. Used by Azure pipeline to deploy the function code."
}

variable "action_group_email_id" {
  type        = string
  description = "(Required) Action group id used to sent alerts via email."
}

variable "action_group_slack_id" {
  type        = string
  description = "(Required) Action group id used to sent alerts via slack."
}

## OPTIONAL

variable "function_app_count" {
  type        = number
  description = "(Optional) Specifies the number of Function App that will be creater (deafult to 1)"
  default     = 1
}

variable "domain" {
  type        = string
  description = "(Optional) Specifies the domain of the Function App."
  default     = "COMMON"
}

variable "storage_account_name" {
  type        = string
  description = "(Optional) Storage account name. If null it will be 'computed'"
  default     = null
}

variable "storage_account_durable_name" {
  type        = string
  description = "(Optional) Storage account name only used by the durable function. If null it will be 'computed'"
  default     = null
}

variable "app_service_plan_name" {
  type        = string
  description = "(Optional) Name of the app service plan. If null it will be 'computed'"
  default     = null
}

variable "runtime_version" {
  type        = string
  default     = "~4"
  description = "(Optional) The runtime version associated with the Function App. Version ~3 is required for Linux Function Apps."
}

variable "storage_account_info" {
  description = "(Optional) The Storage specific configurations. If not specified, will be used the common settings."
  type = object({
    account_kind                      = string # Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to Storage.
    account_tier                      = string # Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid.
    account_replication_type          = string # Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
    access_tier                       = string # Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot.
    advanced_threat_protection_enable = bool
  })

  default = {
    account_kind                      = "StorageV2"
    account_tier                      = "Standard"
    account_replication_type          = "ZRS"
    access_tier                       = "Hot"
    advanced_threat_protection_enable = true
  }
}

variable "app_service_plan_id" {
  type        = string
  description = "(Optional) The external app service plan id to associate to the function. If null a new plan is created, use app_service_plan_info to configure it."
  default     = null
}

variable "app_service_plan_info" {
  type = object({
    kind                         = string # The kind of the App Service Plan to create. Possible values are Windows (also available as App), Linux, elastic (for Premium Consumption) and FunctionApp (for a Consumption Plan).
    sku_tier                     = string # Specifies the plan's pricing tier.
    sku_size                     = string # Specifies the plan's instance size.
    maximum_elastic_worker_count = number # The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan.
  })

  description = "(Optional) Allows to configurate the internal service plan"

  default = {
    kind                         = "Linux"
    sku_tier                     = "PremiumV3"
    sku_size                     = "P1v3"
    maximum_elastic_worker_count = 0
  }
}

variable "pre_warmed_instance_count" {
  type        = number
  description = "(Optional) The number of pre-warmed instances for this function app. Only affects apps on the Premium plan."
  default     = 1
}

variable "always_on" {
  type        = bool
  description = "(Optional) Should the app be loaded at all times? Defaults to null."
  default     = "true"
}

variable "use_32_bit_worker_process" {
  type        = bool
  description = "(Optional) Should the Function App run in 32 bit mode, rather than 64 bit mode? Defaults to false."
  default     = false
}

variable "linux_fx_version" {
  type        = string
  description = "(Optional) Linux App Framework and version for the AppService, e.g. DOCKER|(golang:latest). Use null if function app is on windows"
  default     = "NODE|14"
}

variable "app_settings" {
  type        = map(any)
  description = "(Optional) The environment configurations set to the function. Please note that common configurations are already set by the module: add only your app-specific configurations."
  default     = {}
}

variable "os_type" {
  type        = string
  description = "(Optional) A string indicating the Operating System type for this function app. This value will be linux for Linux derivatives, or an empty string for Windows (default). When set to linux you must also set azurerm_app_service_plan arguments as kind = Linux and reserved = true"
  default     = "linux"
}

variable "https_only" {
  type        = bool
  description = "(Optional) Can the Function App only be accessed only via HTTPS?. Defaults true"
  default     = true
}

variable "allowed_ips" {
  // List of ip
  type        = list(string)
  description = "(Optional) The IP Address used for this IP Restriction in CIDR notation"
  default     = []
}

variable "allowed_subnets" {
  type        = list(string)
  description = "(Optional) List of subnet ids, The Virtual Network Subnet ID used for this IP Restriction. The AZ Devops will be automatic added to beta/staging slots. When creating multiple function ('function_app_count'), each function will be added by the module."
  default     = []
}

variable "cors" {
  type = object({
    allowed_origins = list(string) # A list of origins which should be able to make cross-origin calls. * can be used to allow all calls.
  })
  description = "(Optional) An object containig only the field 'allowed_origins': a list of origins which should be able to make cross-origin calls. * can be used to allow all calls."
  default     = null
}

variable "vnet_integration" {
  type        = bool
  description = "(Optional) Enable vnet integration. Wheter it's true the subnet_id should not be null."
  default     = true
}

variable "internal_storage" {
  description = "(Optional) Create an storage reachable only by the function. It's required for durable function."
  type = object({
    enable                     = bool
    private_endpoint_subnet_id = string
    private_dns_zone_blob_ids  = list(string)
    private_dns_zone_queue_ids = list(string)
    private_dns_zone_table_ids = list(string)
    queues                     = list(string) # Queues names
    containers                 = list(string) # Containers names
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
  description = "(Optional) Path which will be checked for this function app health."
  default     = "/api/v1/info"
}

variable "health_check_maxpingfailures" {
  type        = number
  description = "(Optional) Max ping failures allowed"
  default     = 10
}

variable "export_keys" {
  type        = bool
  description = "(Optional) Export the function keys in the module outputs."
  default     = false
}

variable "tags" {
  type        = map(any)
  description = "(Optional) Set the specified tags to all the resources created by this module."
  default = {
    CreatedBy = "Terraform"
  }
}

variable "system_identity_enabled" {
  type        = bool
  description = "(Optional) Enable the System Identity and create relative Service Principal."
  default     = false
}

# -------------------
# Alerts variables
# -------------------

variable "enable_healthcheck" {
  type        = bool
  description = "(Optional) Enable the healthcheck alert. Default is true"
  default     = true
}

variable "healthcheck_threshold" {
  type        = number
  description = "(Optional) The healthcheck threshold. If metric average is under this value, the alert will be triggered. Default is 50"
  default     = 50
}

variable "action" {
  description = "(Optional) The ID of the Action Group and optional map of custom string properties to include with the post webhook operation."
  type = set(object(
    {
      action_group_id    = string
      webhook_properties = map(string)
    }
  ))
  default = []
}

variable "function_app_autoscale_minimum" {
  type        = number
  description = "(Optional) The minimum number of instances for this resource."
  default     = 1
}

variable "function_app_autoscale_maximum" {
  type        = number
  description = "(Optional) The maximum number of instances for this resource."
  default     = 30
}

variable "function_app_autoscale_default" {
  type        = number
  description = "(Optional) The number of instances that are available for scaling if metrics are not available for evaluation."
  default     = 1
}
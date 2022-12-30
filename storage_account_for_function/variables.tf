variable "location" {
  type        = string
  description = "(Required) Specifies the location where this module will create the resources."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the resource group where this module will create the resources."
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)"
}

variable "private_endpoint_subnet_id" {
  type        = number
  description = "(Required) The subnet id for the private endpoint used to access to blobs"
}

variable "storage_account_durable_name" {
  type        = string
  description = "(Optional) Storage account name only used by the durable function. If null it will be 'computed'"
  default     = null
}

variable "internal_queues" {
  type        = list(string)
  description = "(Optional) a list of queue names. For each name will be craeted a queue in the storage."
  default     = []
}

variable "internal_containers" {
  type        = list(string)
  description = "(Optional) a list of container names. For each name will be craeted a container in the storage."
  default     = []
}

variable "internal_tables" {
  type        = list(string)
  description = "(Optional) a list of table names. For each name will be craeted a table in the storage."
  default     = []
}

variable "blobs_retention_days" {
  type        = number
  description = "(Optional) The retantion of blobs in the container. If not specified, the default is 1 day."
  default     = 1
}

variable "private_dns_zone_blob_ids" {
  type        = list(string)
  description = "(Optional) A list of private dns zone ids for blobs"
  default     = []
}

variable "private_dns_zone_table_ids" {
  type        = list(string)
  description = "(Optional) A list of private dns zone ids for tables"
  default     = []
}

variable "private_dns_zone_queue_ids" {
  type        = list(string)
  description = "(Optional) A list of private dns zone ids for queues"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "(Optional) Set the specified tags to all the resources created by this module."
}

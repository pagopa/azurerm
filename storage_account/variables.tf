variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "account_tier" {
  type = string
}

variable "access_tier" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts."
  default     = null
}

variable "account_replication_type" {
  type = string
}

variable "blob_properties_delete_retention_policy_days" {
  type        = number
  description = "Enable soft delete policy and specify the number of days that the blob should be retained"
  default     = null
}

variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}

variable "enable_https_traffic_only" {
  type    = bool
  default = true
}

variable "allow_blob_public_access" {
  type        = bool
  default     = false
  description = "Allow or disallow public access to all blobs or containers in the storage account."
}

# Note: If specifying network_rules, one of either ip_rules or virtual_network_subnet_ids must be specified
# and default_action must be set to Deny.

variable "network_rules" {
  type = object({
    default_action             = string # Valid option Deny Allow
    bypass                     = set(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "enable_versioning" {
  type        = bool
  description = "Enable versioning in the blob storage account."
  default     = false
}

# versioning

variable "versioning_name" {
  type    = string
  default = null
}

# lock

variable "lock_enabled" {
  type    = bool
  default = false
}

variable "lock_name" {
  type    = string
  default = null
}

variable "lock_level" {
  type    = string
  default = null
}

variable "lock_notes" {
  type    = string
  default = null
}

variable "advanced_threat_protection" {
  type    = string
  default = false
}

variable "tags" {
  type = map(any)
}

variable "index_document" {
  type    = string
  default = null
}

variable "error_404_document" {
  type    = string
  default = null
}
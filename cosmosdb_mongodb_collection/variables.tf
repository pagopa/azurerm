# General Variables
variable "name" {
  type = string
}

variable "lock_enable" {
  type        = bool
  default     = false
  description = "Apply lock to block accedentaly deletions."
}

// Resource Group
variable "resource_group_name" {
  type = string
}

// CosmosDB Mongodb Collection specific variables
variable "cosmosdb_mongo_account_name" {
  type = string
}

variable "cosmosdb_mongo_database_name" {
  type = string
}

variable "ttl" {
  type = number
  default = -1
}

variable "analytical_storage_ttl" {
  type = number
  default = null
}

variable "shard_key" {
  type = string
  default = null
}

variable "throughput" {
  type = number
  default = null
}

variable "indexes" {
  type = list(object({
    keys   = list(string)
    unique = bool
  }))
}

variable "max_throughput" {
  type = number
  default = null
}

variable "timeout_create" {
  type = string
  default = null
}

variable "timeout_update" {
  type    = string
  default = null
}

variable "timeout_read" {
  type    = string
  default = null
}

variable "timeout_delete" {
  type    = string
  default = null
}

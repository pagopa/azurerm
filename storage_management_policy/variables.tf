variable "storage_account_id" {
  type        = string
  description = "Specifies the id of the storage account to apply the management policy to."
}

variable "rules" {
  type = list(object({
    name    = string
    enabled = bool
    filters = object({
      prefix_match = list(string)
      blob_types   = list(string)
    })
    actions = object({
      snapshot = object({
        delete_after_days_since_creation_greater_than = number
      })
      base_blob = object({
        tier_to_cool_after_days_since_modification_greater_than    = number
        tier_to_archive_after_days_since_modification_greater_than = number
        delete_after_days_since_modification_greater_than          = number
      })
    })
  }))
  default = []
}
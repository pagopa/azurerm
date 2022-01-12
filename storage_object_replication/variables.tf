variable "source_storage_account_id" {
  type        = string
  description = "The ID of the source storage account."
}

variable "destination_storage_account_id" {
  type        = string
  description = "The ID of the destination storage account."
}

variable "rules" {
  type = list(
    object({
      source_container_name      = string
      destination_container_name = string
      copy_blobs_created_after   = string
    })
  )

}
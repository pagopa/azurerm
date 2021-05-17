variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type    = string
  default = null
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "terraform_cloud_object_id" {
  type        = string
  default     = null
  description = "Terraform cloud object id to create its access policy."
}

variable "tags" {
  type = map(any)
}
variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "admin_enabled" {
  type        = bool
  description = "Specifies whether the admin user is enabled."
  default     = false
}

variable "georeplications" {
  type        = list(string)
  description = "A list of Azure locations where the container registry should be geo-replicated."
  default     = []
}

variable "tags" {
  type = map(any)
}
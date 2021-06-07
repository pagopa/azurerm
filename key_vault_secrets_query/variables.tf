variable "resource_group" {
  type        = string
  description = "Key vault resource group"
}

variable "key_vault_name" {
  type        = string
  description = "Key vault name"
}

variable "secrets" {
  type        = list(string)
  description = "List of secrets to read"
  default     = []
}

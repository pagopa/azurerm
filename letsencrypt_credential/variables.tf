variable "prefix" {
  type        = string
  description = "Project prefix"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "le_email" {
  type        = string
  description = "Let's encrypt email account"
  default     = "letsencrypt-bots@pagopa.it"
}

variable "key_vault_name" {
  type        = string
  description = "Key vault where save Let's encrypt credentials"
}

variable "subscription_name" {
  type        = string
  description = "Azure subscription name where key vault is located"
}

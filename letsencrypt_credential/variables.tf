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

variable "certbot_version" {
  type        = string
  description = "certbot version from https://hub.docker.com/r/certbot/certbot/tags"
  default     = "v1.29.0@sha256:904fd574583ed30b2ebd3e17a4ab953a69589e0d4860c3199d117ad1dd7a4e94"
}

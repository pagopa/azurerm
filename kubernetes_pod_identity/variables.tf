variable "resource_group_name" {
  type        = string
  description = "Resource group of the Kubernetes cluster."
}

variable "location" {
  type        = string
  description = "Location of the Kubernetes cluster."
}

variable "key_vault" {
  type        = any
  description = "KeyVault azurerm resource where the identity will connect to."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id of the given KeyVault."
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster."
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace."
}

variable "identity_name" {
  type        = string
  description = "Name to use for the identity."
}

variable "secret_permissions" {
  type        = list(string)
  description = "API permissions of the identity to access secrets"
  default     = []
}

variable "key_permissions" {
  type        = list(string)
  description = "API permissions of the identity to access keys"
  default     = []
}

variable "certificate_permissions" {
  type        = list(string)
  description = "API permissions of the identity to access certificates"
  default     = []
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of the Kubernetes cluster"
}

variable "location" {
  type        = string
  description = "Location of the Kubernetes cluster"
}

variable "key_vault" {
  type        = any
  description = "KeyVault azurerm resource"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id of the KeyVault with the certificate."
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace."
}

variable "identity_name" {
  type        = string
  description = "Kubernetes namespace."
}

variable "secret_permissions" {
  type        = list(string)
  description = ""
  default     = []
}

variable "key_permissions" {
  type        = list(string)
  description = ""
  default     = []
}

variable "certificate_permissions" {
  type        = list(string)
  description = ""
  default     = []
}


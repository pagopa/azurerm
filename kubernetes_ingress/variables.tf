variable "namespace" {
  type        = string
  description = "Kubernetes namespace."
}

variable "rules" {
  type = list(object({
    path         = string
    service_name = string
    service_port = number
  }))
  description = "List of ingress rules."
}

variable "name" {
  type        = string
  description = "Ingress name."
}

variable "host" {
  type        = string
  description = "Ingress host, it supports only one host per ingress."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id of the KeyVault with the TLS certificate."
}

variable "location" {
  type        = string
  description = "Location of the Kubernetes cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of the Kubernetes cluster."
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster."
}

variable "key_vault" {
  type        = any
  description = "KeyVault azurerm resource."
}

variable "force_ssl_redirect" {
  type        = bool
  description = "Force ssl redirect."
}

locals {
  secret_name   = replace(var.host, ".", "-")
  identity_name = "${var.namespace}-ingress-pod-identity"
}

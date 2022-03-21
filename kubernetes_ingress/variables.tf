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
  description = "Ingress rules."
}

variable "name" {
  type        = string
  description = "Ingress name."
}

variable "host" {
  type        = string
  description = "Ingress host."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id of the KeyVault with the certificate."
}

variable "location" {
  type        = string
  description = "Location of the Kubernetes cluster"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of the Kubernetes cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "keyvault" {
  type        = any
  description = "KeyVault azurerm resource"
}

locals {
  secret_name = replace(var.host, ".", "-")
}

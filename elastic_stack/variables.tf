variable "kibana_external_domain" {
  description = "Kibana external domain"
  type        = string
}

variable "secret_name" {
  description = "Secret certificate name"
  type        = string
}

variable "keyvault_name" {
  description = "Keyvault name"
  type        = string
}

variable "kibana_internal_hostname" {
  description = "Kibana internal hostname"
  type        = string
}


variable "namespace" {
  description = "Namespace for ECK Operator"
  type        = string
  default = "elastic-system"
}


variable "nodeset_config" {
  type = map(object({
    count = string
    roles  = list(string)
    storage = string
    storageClassName= string
  }))
  default = {
    default = {
      count = 1
      roles = ["master", "data", "data_content", "data_hot", "data_warm", "data_cold", "data_frozen", "ingest", "ml", "remote_cluster_client", "transform"]
      storage = "5Gi"
      storageClassName = "standard"
    }
  }
}
variable "location" {
  description = "Azure Location in which the resources are located"
  type = string
}

variable "resource_group_name" {
  description = "Resource Group in which the resources are located"
  type = string
}

variable "name" {
  description = "Short Resource Name, used to customize subresource names"
  type = string
}

variable "name_prefix" {
  description = "String to be prefixed to resource names created by this module"
  type = string
}

variable "github_conf" {
  description = "Configuration of the github repo associated to the data factory"
  type = object({
    account_name = string
    branch_name = string
    git_url = string
    repository_name = string
    root_folder = string
  })
}

variable "private_dns_zone" {
  description = "Private DNS Zone where the private endpoint will be created"
  type = object({
    id   = string
    name = string
  })
}

variable "subnet_id" {
  description = "ID of the subnet in which the private endpoint is created"
  type = string
}

variable "resources_managed_private_enpoint" {
  description = ""
  type = list(object({
    id   = string
    name = string
  }))
}


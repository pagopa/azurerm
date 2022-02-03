variable "location" {
  description = "Azure Location in which the resources are located"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group in which the resources are located"
  type        = string
}

variable "name" {
  description = "Short Resource Name, used to customize subresource names"
  type        = string
}

variable "custom_domain_enabled" {
  description = "If not null enables custom domain for the private endpoint"
  type        = string
}

variable "github_conf" {
  description = "Configuration of the github repo associated to the data factory"
  type = object({
    account_name    = string
    branch_name     = string
    git_url         = string
    repository_name = string
    root_folder     = string
  })
}

variable "private_endpoint" {
  description = "Enable private endpoint with required params"
  type = object({
    enabled   = bool
    subnet_id = string
    private_dns_zone = object({
      id   = string
      name = string
      rg   = string
    })
  })
}

variable "resources_managed_private_enpoint" {
  description = "Map of resource to which a data factory must connect via managed private endpoint"
  type        = map(string)
}

variable "tags" {
  type = map(any)
}

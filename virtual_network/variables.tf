variable "name" {
  type        = string
  description = "The name of the virtual network. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "address_space" {
  type = list(string)
}

variable "ddos_protection_plan" {
  type = object({
    id     = string
    enable = bool
  })

  default = null
}

variable "tags" {
  type = map(any)
}

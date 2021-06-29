variable "name" {
  type        = string
  description = "Firewall name"
}

variable "location" {
  type = string
}

// Resource Group 
variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type        = string
  description = "Sku name of the Firewall."
  default     = null
}

variable "sku_tier" {
  type        = string
  description = "Sku tier of the Firewall."
  default     = "Standard"
}

variable "ip_configurations" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
}

variable "public_ip_address_id" {
  type        = string
  description = "Public ip address id, wether already defined."
  default     = null
}

variable "tags" {
  type = map(any)
}

variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  description = "ID of subnet where jumpbox VM will be installed"
  type        = string
}

variable "source_address_prefix" {
  type        = string
  description = "CIDR or source IP range or * to match any IP. ue"
  default     = "*"

}

variable "admin_username" {
  description = "Jumpbox VM user name"
  type        = string
  default     = "azureuser"
}

variable "size" {
  type        = string
  default     = "Standard_DS1_v2"
  description = "The SKU which should be used for this Virtual Machine,"
}

variable "publisher" {
  type        = string
  default     = "Canonical"
  description = "Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from."
}

variable "offer" {
  type        = string
  default     = "UbuntuServer"
  description = "Specifies the offer of the image used to create the virtual machines."
}

variable "sku" {
  type        = string
  description = "Specifies the SKU of the image used to create the virtual machines."
  default     = "16.04-LTS"
}

variable "image_version" {
  type        = string
  default     = "latest"
  description = "Specifies the version of the image used to create the virtual machines."

}

variable "remote_exec_inline_commands" {
  type        = list(string)
  description = "List of bash command executed remotely when the vm is created."
  default     = []
}

variable "pip_allocation_method" {
  type        = string
  default     = "Dynamic"
  description = "Public IP allocation method."
}

variable "tags" {
  type = map(any)
}
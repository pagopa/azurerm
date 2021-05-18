variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
}

variable "notification_sender_email" {
  type        = string
  description = "Email address from which the notification will be sent."
  default     = null
}

variable "sku_name" {
  type    = string
  default = "A string consisting of two parts separated by an underscore(_). The first part is the name, valid values include: Consumption, Developer, Basic, Standard and Premium. The second part is the capacity (e.g. the number of deployed units of the sku), which must be a positive integer (e.g. Developer_1)."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The id of the subnet that will be used for the API Management."
}

variable "application_insights_instrumentation_key" {
  type        = string
  default     = null
  description = "The instrumentation key used to push data to Application Insights."
}

variable "virtual_network_type" {
  type        = string
  description = "The type of virtual network you want to use, valid values include."
  default     = null
}

variable "policy_path" {
  type    = string
  default = null
}

variable "tags" {
  type = map(any)
}
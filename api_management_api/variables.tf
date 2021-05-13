variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "api_management_name" {
  type = string
}

variable "display_name" {
  type = string
}

variable "description" {
  type = string
}

variable "service_url" {
  type = string
}

variable "revision" {
  type    = string
  default = "1"
}

variable "path" {
  type = string
}

variable "protocols" {
  type = list(string)
}

variable "subscription_required" {
  type        = bool
  default     = false
  description = "Should this API require a subscription key?"
}

variable "content_format" {
  type        = string
  description = "The format of the content from which the API Definition should be imported."
  default     = "swagger-json"
}

variable "content_value" {
  type        = string
  description = "The Content from which the API Definition should be imported."
}

variable "xml_content" {
  type        = string
  description = "The XML Content for this Policy as a string"
  default     = null
}

variable "product_ids" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(any)
}
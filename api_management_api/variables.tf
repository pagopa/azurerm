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

variable "revision_description" {
  type    = string
  default = null
}

variable "oauth2_authorization" {
  type = object({
    authorization_server_name = string
    }
  )
  default = {
    authorization_server_name = null
  }
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

variable "api_operation_policies" {
  type = list(object({
    operation_id = string
    xml_content  = string
    }
  ))
  default     = []
  description = "List of api policy for given operation."
}

variable "api_version" {
  type        = string
  description = "The Version number of this API, if this API is versioned."
  default     = null
}

variable "version_set_id" {
  type        = string
  description = "The ID of the Version Set which this API is associated with."
  default     = null
}

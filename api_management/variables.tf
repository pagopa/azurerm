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

variable "diagnostic_sampling_percentage" {
  type        = number
  default     = 5.0
  description = "Sampling (%). For high traffic APIs, please read the documentation to understand performance implications and log sampling. Valid values are between 0.0 and 100.0."
}

variable "diagnostic_always_log_errors" {
  type        = bool
  default     = true
  description = "Always log errors. Send telemetry if there is an erroneous condition, regardless of sampling settings."
}

variable "diagnostic_log_client_ip" {
  type        = bool
  default     = true
  description = "Log client IP address."
}

variable "diagnostic_http_correlation_protocol" {
  type        = string
  default     = "W3C"
  description = "The HTTP Correlation Protocol to use. Possible values are None, Legacy or W3C."
}

variable "diagnostic_verbosity" {
  type        = string
  default     = "error"
  description = "Logging verbosity. Possible values are verbose, information or error."
}

variable "diagnostic_backend_request" {
  description = "Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1"
  type = set(object(
    {
      body_bytes     = number
      headers_to_log = set(string)
    }
  ))
  default = []
}

variable "diagnostic_backend_response" {
  description = "Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1"
  type = set(object(
    {
      body_bytes     = number
      headers_to_log = set(string)
    }
  ))
  default = []
}

variable "diagnostic_frontend_request" {
  description = "Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1"
  type = set(object(
    {
      body_bytes     = number
      headers_to_log = set(string)
    }
  ))
  default = []
}

variable "diagnostic_frontend_response" {
  description = "Number of payload bytes to log (up to 8192) and a list of headers to log, min items: 0, max items: 1"
  type = set(object(
    {
      body_bytes     = number
      headers_to_log = set(string)
    }
  ))
  default = []
}


variable "tags" {
  type = map(any)
}

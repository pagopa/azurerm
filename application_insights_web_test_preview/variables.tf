variable "subscription_id" {
  type        = string
  description = "(Required) subscription id."
}

variable "name" {
  type        = string
  description = "(Required) Web test name"
}

variable "resource_group" {
  type        = string
  description = "Resource group name"
}

variable "application_insight_name" {
  type        = string
  description = "Application insight instance name."
}

variable "frequency" {
  type        = number
  description = "Interval in seconds between test runs for this WebTest."
  default     = 300
}

variable "timeout" {
  type        = number
  description = "Seconds until this WebTest will timeout and fail."
  default     = 30
}

variable "request_url" {
  type        = string
  description = "Url to check."

}

variable "expected_http_status" {
  type        = number
  description = "Expeced http status code."
  default     = 200
}

variable "ignore_http_status" {
  type        = bool
  description = "Ignore http status code."
  default     = false

}

variable "ssl_cert_remaining_lifetime_check" {
  type        = number
  description = "Days before the ssl certificate will expire. An expiry certificate will cause the test failing."
  default     = 7
}

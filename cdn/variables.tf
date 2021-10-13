variable "prefix" {
  type = string
}
variable "name" {
  type = string
}

variable "storage_account_kind" {
  type    = string
  default = "StorageV2"
}

variable "storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "storage_account_replication_type" {
  type    = string
  default = "GRS"
}

variable "storage_access_tier" {
  type    = string
  default = "Hot"
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "resource_group_name" {
  type = string
}

variable "querystring_caching_behaviour" {
  type    = string
  default = "IgnoreQueryString"
}

variable "global_delivery_rule" {
  type = object({
    cache_expiration_action = list(object({
      behavior = string
      duration = string
    }))
    cache_key_query_string_action = list(object({
      behavior   = string
      parameters = string
    }))
    modify_request_header_action = list(object({
      action = string
      name   = string
      value  = string
    }))
    modify_response_header_action = list(object({
      action = string
      name   = string
      value  = string
    }))
  })
  # TODO improvements
  # validation {
  #   condition = (
  #     length(var.global_delivery_rule.modify_response_header_action[*].value) <= 128
  #   )
  #   error_message = "Max length is 128 chars."
  # }
  default = null
}

variable "delivery_rule_url_path_condition_cache_expiration_action" {
  type = list(object({
    name            = string
    order           = number
    operator        = string
    match_values    = list(string)
    behavior        = string
    duration        = string
    response_action = string
    response_name   = string
    response_value  = string
  }))
  default = []
}

variable "delivery_rule_request_scheme_condition" {
  type = list(object({
    name         = string
    order        = number
    operator     = string
    match_values = list(string)
    url_redirect_action = object({
      redirect_type = string
      protocol      = string
      hostname      = string
      path          = string
      fragment      = string
      query_string  = string
    })
  }))
  default = []
}

variable "delivery_rule_redirect" {
  type = list(object({
    name         = string
    order        = number
    operator     = string
    match_values = list(string)
    url_redirect_action = object({
      redirect_type = string
      protocol      = string
      hostname      = string
      path          = string
      fragment      = string
      query_string  = string
    })
  }))
  default = []
}

variable "https_rewrite_enabled" {
  type    = bool
  default = true
}

variable "hostname" {
  type = string
}

variable "lock_enabled" {
  type = bool
}

variable "dns_zone_name" {
  type = string
}

variable "dns_zone_resource_group_name" {
  type = string
}

variable "index_document" {
  type    = string
}

variable "error_404_document" {
  type    = string
}
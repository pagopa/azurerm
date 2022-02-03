variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "name" {
  type = string
}

variable "sku_name" {
  type        = string
  description = "SKU Name of the App GW"
}

variable "sku_tier" {
  type        = string
  description = "SKU tier of the App GW"
}

# Networkig

variable "subnet_id" {
  type        = string
  description = "Subnet dedicated to the app gateway"
}

variable "public_ip_id" {
  type        = string
  description = "Public IP"
}

variable "backends" {
  type = map(object({
    protocol                    = string
    host                        = string
    port                        = number
    ip_addresses                = list(string)
    fqdns                       = list(string)
    probe                       = string
    probe_name                  = string
    request_timeout             = number
    pick_host_name_from_backend = bool
  }))
}

variable "listeners" {
  type = map(object({
    protocol           = string
    host               = string
    port               = number
    ssl_profile_name   = string
    firewall_policy_id = string
    certificate = object({
      name = string
      id   = string
    })
  }))
}

variable "ssl_profiles" {
  type = list(object({
    name                             = string
    trusted_client_certificate_names = list(string)
    verify_client_cert_issuer_dn     = bool

    ssl_policy = object({
      disabled_protocols   = list(string)
      policy_type          = string
      policy_name          = string
      cipher_suites        = list(string)
      min_protocol_version = string
    })
  }))
  default = []
}

# Note: the attribute secret_name refers to the secret contaning the client certificate.
# Secrects'name in the key vault can't have low hyphens but just hyphens in it.
variable "trusted_client_certificates" {
  type = list(object({
    secret_name  = string
    key_vault_id = string
  }))
}

variable "routes" {
  type = map(object({
    listener              = string
    backend               = string
    rewrite_rule_set_name = string
  }))
}

variable "rewrite_rule_sets" {
  type = list(object({
    name = string
    rewrite_rules = list(object({
      name          = string
      rule_sequence = number
      condition = object({
        variable    = string
        pattern     = string
        ignore_case = bool
        negate      = bool
      })

      request_header_configurations = list(object({
        header_name  = string
        header_value = string
      }))

      response_header_configurations = list(object({
        header_name  = string
        header_value = string
      }))

      url = object({
        path         = string
        query_string = string
      })

    }))
  }))
  default = []
}

# TLS

variable "identity_ids" {
  type = list(string)
}

# WAF
variable "waf_enabled" {
  type        = bool
  description = "Enable WAF"
  default     = true
}

variable "waf_disabled_rule_group" {
  type = list(object({
    rule_group_name = string
    rules           = list(string)
  }))
  default = []
}

# Scaling

variable "app_gateway_max_capacity" {
  type = string
}

variable "app_gateway_min_capacity" {
  type = string
}

variable "sec_log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Log analytics workspace security (it should be in a different subscription)."
}

variable "sec_storage_id" {
  type        = string
  default     = null
  description = "Storage Account security (it should be in a different subscription)."
}

# Monitoring

variable "alerts_enabled" {
  type        = bool
  default     = true
  description = "Should Metric Alerts be enabled?"
}

variable "action" {
  description = "The ID of the Action Group and optional map of custom string properties to include with the post webhook operation."
  type = set(object(
    {
      action_group_id    = string
      webhook_properties = map(string)
    }
  ))
  default = []
}

variable "monitor_metric_alert_criteria" {
  default = {}

  description = <<EOD
Map of name = criteria objects, see these docs for options
https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftnetworkapplicationgateways
EOD

  type = map(object({

    description = string
    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H
    frequency = string
    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.
    window_size = string
    # Possible values are 0, 1, 2, 3.
    severity = number
    # Possible values are true, false
    auto_mitigate = bool

    # static
    criteria = list(object(
      {
        # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
        aggregation = string
        metric_name = string
        # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
        operator  = string
        threshold = number

        dimension = list(object(
          {
            name     = string
            operator = string
            values   = list(string)
          }
        ))
      }
    ))

    # dynamic
    dynamic_criteria = list(object(
      {
        # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
        aggregation = string
        metric_name = string
        # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
        operator = string
        # Possible values are Low, Medium, High
        alert_sensitivity = string

        evaluation_total_count   = number
        evaluation_failure_count = number

        dimension = list(object(
          {
            name     = string
            operator = string
            values   = list(string)
          }
        ))
      }
    ))
  }))
}

variable "tags" {
  type = map(any)
}

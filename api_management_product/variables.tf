variable "product_id" {
  type        = string
  description = "The Identifier for this Product, which must be unique within the API Management Service."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the API Management Service should be exist."
}

variable "api_management_name" {
  type        = string
  description = "The name of the API Management Service."
}

variable "display_name" {
  type        = string
  description = "The Display Name for this API Management Product."
}

variable "description" {
  type        = string
  description = "A description of this Product, which may include HTML formatting tags."
}

variable "subscription_required" {
  type        = bool
  description = "Is a Subscription required to access API's included in this Product?"
}

variable "subscriptions_limit" {
  type        = number
  description = "The number of subscriptions a user can have to this Product at the same time."
  default     = null
}

variable "approval_required" {
  type        = bool
  description = "Do subscribers need to be approved prior to being able to use the Product?"
}

variable "published" {
  type        = bool
  description = "Is this Product Published?"
}

variable "policy_xml" {
  type        = string
  description = "(Optional) The XML Content for this Product Policy."
  default     = null
}

variable "groups" {
  type        = set(string)
  description = "(Optional) The groups where the product is included"
  default     = []
}

variable "location" {
  type        = string
  description = "(Required) Location of the Kubernetes cluster."
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Changing this forces a new resource to be created."
}

variable "key_vault_id" {
  type        = any
  description = "(Required) Specifies the id of the Key Vault resource. Changing this forces a new resource to be created."
  default     = null
}

#
# AKS
#

variable "resource_group_name" {
  type        = string
  description = "(Required) Resource group of the Kubernetes cluster."
}

variable "cluster_name" {
  type        = string
  description = "(Required) Name of the Kubernetes cluster."
}

variable "namespace" {
  type        = string
  description = "(Required) Kubernetes namespace where the pod identity will be create."
}

variable "identity_name" {
  type        = string
  description = "(Required) The name of the user assigned identity and POD identity. Changing this forces a new identity to be created."
}

#
# Key Vault Permissions
#
variable "secret_permissions" {
  type        = list(string)
  description = "(Optional) API permissions of the identity to access secrets, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set."
  default     = []
}

variable "key_permissions" {
  type        = list(string)
  description = "(Optional) API permissions of the identity to access keys, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey."
  default     = []
}

variable "certificate_permissions" {
  type        = list(string)
  description = "(Optional) API permissions of the identity to access certificates, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update."
  default     = []
}

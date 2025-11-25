variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = ""  # Empty default to force explicit naming
}

variable "location" {
    type = string
}
variable "resource_group_name" {
    type = string
}

variable "service_principal_name" {
    type = string
}

variable "service_principal_object_id" {}
variable "service_principal_tenant_id" {}



variable "environment" {
    type = string
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "aks"
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "SEU-Vnet"
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = string
  default     = "10.10.0.0/16"
}

variable "aks_subnet_address_prefix" {
  description = "AKS subnet address prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_endpoints_subnet_address_prefix" {
  description = "Private endpoints subnet address prefix"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
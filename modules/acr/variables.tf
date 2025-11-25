variable "acr_name" {
  description = "Name of the Azure Container Registry. Must be globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where ACR will be created"
  type        = string
}

variable "sku" {
  description = "SKU of the container registry (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the container registry"
  type        = bool
  default     = true
}

variable "anonymous_pull_enabled" {
  description = "Whether anonymous pull access is enabled"
  type        = bool
  default     = false
}

variable "data_endpoint_enabled" {
  description = "Whether to enable dedicated data endpoints for this container registry"
  type        = bool
  default     = false
}

variable "create_private_endpoint" {
  description = "Whether to create a private endpoint for ACR"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint (required if create_private_endpoint is true)"
  type        = string
  default     = null
}

variable "service_principal_object_id" {
  description = "Object ID of service principal to grant ACR access"
  type        = string
  default     = null
}

variable "georeplication_locations" {
  description = "List of Azure regions where the container registry should be geo-replicated (Premium SKU only)"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
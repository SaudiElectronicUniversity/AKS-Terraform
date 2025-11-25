variable "sub_name" {
  description = "Name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_prefix" {
  description = "Address prefix for the subnet (CIDR notation)"
  type        = string
}

variable "service_endpoints" {
  description = "List of service endpoints to enable on the subnet"
  type        = list(string)
  default     = []
}

variable "network_security_group_id" {
  description = "ID of the network security group to associate with the subnet"
  type        = string
  default     = null
}

# Remove or comment out this variable since we're not using it
# variable "private_endpoint_network_policies_enabled" {
#   description = "Whether to enable network policies for private endpoints"
#   type        = bool
#   default     = false
# }

variable "service_delegation" {
  description = "Service delegation for the subnet"
  type        = string
  default     = null
}
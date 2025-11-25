variable "Bastion_prefix" {
  description = "Bastion_prefix for all resources"
  type        = string
  default     = "bastion"
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the bastion VM"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_size" {
  description = "VM size for bastion"
  type        = string
  default     = "Standard_B2s"
}

variable "allowed_ssh_ips" {
  description = "Allowed IP ranges for SSH access"
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
# Resource Group Configuration
variable "rgname" {
  type        = string
  description = "Resource group name"
  default     = "SEU-Test-RG"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "West Europe"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
  default     = "SEU-Vnet"
}

# Service Principal Configuration
variable "service_principal_name" {
  type        = string
  description = "Service Principal name"
  default     = "AKS-SP"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

# AKS Cluster Configuration
variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS Cluster"
  default     = "SEU-Test-AKS"
}

# Key Vault Configuration
variable "keyvault_name" {
  type        = string
  description = "Key Vault name"
  default     = ""
}

# Tags and Environment
variable "environment" {
  type        = string
  description = "Environment name"
  default     = ""
}

variable "system" {
  type        = string
  description = "System name"
  default     = ""
}

# Network Configuration
variable "prefix" {
  type        = string
  description = "Prefix for all resources"
  default     = "seu"
}

variable "Bastion_prefix" {
  type        = string
  description = "Bastion_prefix for all resources"
  default     = "seu"
}

variable "vnet_address_space" {
  type        = string
  description = "VNet address space"
  default     = "10.0.0.0/16"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "AKS subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "private_endpoints_subnet_cidr" {
  type        = string
  description = "Private endpoints subnet CIDR"
  default     = "10.0.2.0/24"
}

variable "bastion_subnet_cidr" {
  type        = string
  description = "Bastion subnet CIDR"
  default     = "10.0.6.0/24"
}

# AKS Network Configuration
variable "private_cluster_enabled" {
  type        = bool
  description = "Enable private AKS cluster"
  default     = true
}

variable "node_count" {
  type        = number
  description = "Number of AKS nodes"
  default     = 2
}

variable "service_cidr" {
  type        = string
  description = "Kubernetes service CIDR"
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  type        = string
  description = "Kubernetes DNS service IP"
  default     = "10.1.0.10"
}

# SSH Key
variable "ssh_public_key" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/aks_id_ed25519.pub"
}

# Bastion VM Configuration 
variable "bastion_admin_username" {
  description = "Admin username for bastion VM"
  type        = string
  default     = "adminuser"
}

variable "bastion_vm_size" {
  description = "VM size for bastion"
  type        = string
  default     = "Standard_B1s"
}

variable "allowed_ssh_cidr" {
  description = "Allowed CIDR for SSH access to bastion"
  type        = string
  default     = "0.0.0.0/0"
}

# Database Subnet Variables
variable "db_subnet_name" {
  description = "Name of the database subnet"
  type        = string
  default     = "seuaks-db-subnet"
}

variable "db_subnet_address" {
  description = "CIDR range for database subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "db_service_endpoints" {
  description = "Service endpoints for database subnet"
  type        = list(string)
  default     = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

# Staging LB Subnet Variables
variable "staging_lb_subnet_name" {
  description = "Name of the staging load balancer subnet"
  type        = string
  default     = "seuaks-staging-lb-subnet"
}

variable "staging_lb_subnet_cidr" {
  description = "CIDR range for staging load balancer subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "staging_lb_service_endpoints" {
  description = "Service endpoints for staging load balancer subnet"
  type        = list(string)
  default     = ["Microsoft.Storage"]
}

# Production LB Subnet Variables
variable "production_lb_subnet_name" {
  description = "Name of the production load balancer subnet"
  type        = string
  default     = "seuaks-production-lb-subnet"
}

variable "production_lb_subnet_cidr" {
  description = "CIDR range for production load balancer subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "production_lb_service_endpoints" {
  description = "Service endpoints for production load balancer subnet"
  type        = list(string)
  default     = ["Microsoft.Storage"]
}

# ACR Variables
variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique)"
  type        = string
  default     = "acrseutest001"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = false
}

variable "acr_private_endpoint_enabled" {
  description = "Enable private endpoint for ACR"
  type        = bool
  default     = true
}

# PostgreSQL Variables
variable "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
  default     = "pg-seu-test-001"
}

variable "postgresql_admin_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "psqladmin"
}

variable "postgresql_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "postgresql_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "13"
}

variable "postgresql_sku" {
  description = "PostgreSQL SKU"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

variable "postgresql_storage_mb" {
  description = "PostgreSQL storage in MB"
  type        = number
  default     = 32768
}

variable "postgresql_databases" {
  description = "List of databases to create"
  type        = list(string)
  default     = ["appdb", "authdb"]
}

variable "postgresql_backup_retention" {
  description = "Backup retention in days"
  type        = number
  default     = 7
}

variable "postgresql_ha_mode" {
  description = "High availability mode"
  type        = string
  default     = "Disabled"
}

variable "postgresql_configurations" {
  description = "PostgreSQL server configurations"
  type        = map(string)
  default = {
    "azure.extensions"            = "UUID-OSSP,PGCrypto"
    "pg_stat_statements.track"    = "all"
    "shared_preload_libraries"    = "pg_stat_statements"
    "log_min_duration_statement"  = "5000"
  }
}
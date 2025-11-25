# Required variables
variable "server_name" {
  description = "Name of the PostgreSQL flexible server"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where PostgreSQL will be created"
  type        = string
}

# Server configuration
variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "13"
}

variable "administrator_login" {
  description = "Administrator login for PostgreSQL server"
  type        = string
  default     = "psqladmin"
}

variable "administrator_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

# SKU and Storage
variable "sku_name" {
  description = "SKU name for PostgreSQL server"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

variable "storage_mb" {
  description = "Max storage allowed for the server in MB"
  type        = number
  default     = 32768
}

# Backup and HA
variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}

variable "high_availability_mode" {
  description = "High availability mode"
  type        = string
  default     = "Disabled"
}

# Network
variable "delegated_subnet_id" {
  description = "Delegated subnet ID for private access"
  type        = string
}

variable "virtual_network_id" {
  description = "Virtual network ID for DNS linking"
  type        = string
}

# Authentication
variable "active_directory_auth_enabled" {
  description = "Enable Active Directory authentication"
  type        = bool
  default     = false
}

variable "password_auth_enabled" {
  description = "Enable password authentication"
  type        = bool
  default     = true
}

# Maintenance
variable "maintenance_day_of_week" {
  description = "Maintenance window day of week (0-6, where 0=Sunday)"
  type        = number
  default     = 0
}

variable "maintenance_start_hour" {
  description = "Maintenance window start hour (0-23)"
  type        = number
  default     = 0
}

variable "maintenance_start_minute" {
  description = "Maintenance window start minute (0-59)"
  type        = number
  default     = 0
}

# Databases
variable "databases" {
  description = "List of databases to create"
  type        = list(string)
  default     = ["appdb"]
}

variable "database_charset" {
  description = "Database charset"
  type        = string
  default     = "UTF8"
}

variable "database_collation" {
  description = "Database collation"
  type        = string
  default     = "en_US.utf8"
}

# Configuration
variable "server_configurations" {
  description = "PostgreSQL server configurations"
  type        = map(string)
  default     = {}
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Add this to your modules/postgresql/variables.tf file:
variable "private_dns_zone_id" {
  description = "Private DNS Zone ID for PostgreSQL private endpoint"
  type        = string
}
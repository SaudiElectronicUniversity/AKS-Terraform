# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  # SKU configuration
  sku_name   = var.sku_name
  storage_mb = var.storage_mb

  # Backup configuration
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # High availability - REQUIRED FOR PRIVATE ACCESS
  dynamic "high_availability" {
    for_each = var.high_availability_mode != "Disabled" ? [1] : []
    content {
      mode = var.high_availability_mode
    }
  }

  # Network configuration - Private Access using delegated subnet
  delegated_subnet_id          = var.delegated_subnet_id
  private_dns_zone_id          = var.private_dns_zone_id  # Uses DNS zone from main.tf
  public_network_access_enabled = false

  # Authentication
  authentication {
    active_directory_auth_enabled = var.active_directory_auth_enabled
    password_auth_enabled         = var.password_auth_enabled
  }

  # Maintenance window
  maintenance_window {
    day_of_week  = var.maintenance_day_of_week
    start_hour   = var.maintenance_start_hour
    start_minute = var.maintenance_start_minute
  }

  tags = var.tags

  # Lifecycle to fix zone errors
  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }

}

# PostgreSQL Databases
resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each = toset(var.databases)

  name      = each.value
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  charset   = var.database_charset
  collation = var.database_collation
}

# PostgreSQL Configurations
resource "azurerm_postgresql_flexible_server_configuration" "configurations" {
  for_each = var.server_configurations

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  value     = each.value
}
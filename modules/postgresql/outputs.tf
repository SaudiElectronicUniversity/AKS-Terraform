# KEEP ONLY THESE OUTPUTS - REMOVE ALL DUPLICATES

output "server_id" {
  description = "ID of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.postgresql.id
}

output "server_name" {
  description = "Name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.postgresql.name
}

output "fqdn" {
  description = "Fully qualified domain name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.postgresql.fqdn
}

output "administrator_login" {
  description = "Administrator login username"
  value       = var.administrator_login
}

output "administrator_password" {
  description = "Administrator password"
  value       = var.administrator_password
  sensitive   = true
}

output "connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${var.administrator_login}:${var.administrator_password}@${azurerm_postgresql_flexible_server.postgresql.fqdn}:5432/${length(var.databases) > 0 ? var.databases[0] : "postgres"}"
  sensitive   = true
}

output "databases" {
  description = "List of created databases"
  value       = [for db in azurerm_postgresql_flexible_server_database.databases : db.name]
}



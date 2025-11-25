# Resource Group
output "resource_group_name" {
  value = azurerm_resource_group.rg1.name
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = module.ServicePrincipal.client_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = module.ServicePrincipal.client_secret
  sensitive   = true
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.network.vnet_name
}

output "aks_subnet_name" {
  description = "AKS subnet name"
  value       = module.network.aks_subnet_name
}

output "private_endpoints_subnet_id" {
  description = "Private endpoints subnet ID"
  value       = module.network.private_endpoints_subnet_id
}

# Database subnet Info - UPDATED: Use direct resource reference
output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database_subnet.id
}

output "database_subnet_name" {
  description = "Name of the database subnet"
  value       = azurerm_subnet.database_subnet.name
}

# COMMENTED OUT: Simple bastion outputs
/*
output "bastion_public_ip" {
  description = "Bastion public IP address"
  value       = module.bastion.bastion_public_ip
}

output "bastion_admin_username" {
  description = "Bastion admin username"
  value       = module.bastion.admin_username
}

output "bastion_connection_instructions" {
  description = "Instructions to connect to bastion"
  value       = <<EOT
SSH to bastion: ssh ${module.bastion.admin_username}@${module.bastion.bastion_public_ip}

Once connected to bastion, run:
az login
az aks get-credentials --resource-group ${var.rgname} --name ${var.aks_cluster_name}
kubectl get nodes
EOT
}
*/

# Staging LB Subnet Outputs
output "staging_lb_subnet_id" {
  description = "ID of the staging load balancer subnet"
  value       = module.staging_lb_subnet.subnet_id
}

output "staging_lb_subnet_name" {
  description = "Name of the staging load balancer subnet"
  value       = module.staging_lb_subnet.subnet_name
}

# Production LB Subnet Outputs
output "production_lb_subnet_id" {
  description = "ID of the production load balancer subnet"
  value       = module.production_lb_subnet.subnet_id
}

output "production_lb_subnet_name" {
  description = "Name of the production load balancer subnet"
  value       = module.production_lb_subnet.subnet_name
}

# ACR Outputs
output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = module.acr.acr_id
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "Login server URL of the ACR"
  value       = module.acr.acr_login_server
}

# COMMENTED OUT: PostgreSQL Outputs
/*
output "postgresql_fqdn" {
  description = "PostgreSQL server FQDN"
  value       = module.postgresql.fqdn
}

output "postgresql_databases" {
  description = "List of PostgreSQL databases"
  value       = module.postgresql.databases
}

output "postgresql_connection_string" {
  description = "PostgreSQL connection string (sensitive)"
  value       = module.postgresql.connection_string
  sensitive   = true
}

output "postgresql_server_id" {
  description = "PostgreSQL server ID"
  value       = module.postgresql.server_id
}
*/
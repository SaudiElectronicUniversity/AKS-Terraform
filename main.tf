# Main Terraform configuration file for APIM-AKS infrastructure
# This file orchestrates the deployment of all infrastructure components

# Create Azure Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

# Create Azure Service Principal for AKS and other services
module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name
}

# Assign Contributor role to Service Principal at subscription level
resource "azurerm_role_assignment" "rolespn" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id
}

# Create virtual network and subnets
module "network" {
  source = "./modules/network"

  vnet_name              = var.vnet_name
  location            = var.location
  resource_group_name = var.rgname

  vnet_address_space     = var.vnet_address_space
  aks_subnet_address_prefix = var.aks_subnet_cidr
  private_endpoints_subnet_address_prefix = var.private_endpoints_subnet_cidr

  tags = {
    environment = var.environment
    project     = "APIM-aks"
  }
}

# Create Network Security Group for Database Subnet
module "database_nsg" {
  source = "./modules/nsg"

  nsg_name            = "${var.prefix}-db-nsg"
  location            = var.location
  resource_group_name = var.rgname
  security_rules      = local.db_security_rules
  
  tags = {
    environment = var.environment
    purpose     = "database"
  }
}

# Create Network Security Group for Staging LB Subnet
module "staging_lb_nsg" {
  source = "./modules/nsg"

  nsg_name            = "${var.prefix}-staging-nsg"
  location            = var.location
  resource_group_name = var.rgname
  security_rules      = local.staging_lb_security_rules
  
  tags = {
    environment = var.environment
    purpose     = "staging-lb"
  }
}

# Create Network Security Group for Production LB Subnet
module "production_lb_nsg" {
  source = "./modules/nsg"

  nsg_name            = "${var.prefix}-production-nsg"
  location            = var.location
  resource_group_name = var.rgname
  security_rules      = local.production_lb_security_rules
  
  tags = {
    environment = var.environment
    purpose     = "production-lb"
  }
}

# Database Subnet with PostgreSQL delegation
resource "azurerm_subnet" "database_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = var.rgname
  virtual_network_name = module.network.vnet_name
  address_prefixes     = [var.db_subnet_address]

  service_endpoints = var.db_service_endpoints

  # Required delegation for PostgreSQL
  delegation {
    name = "postgresql-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# NSG association for database subnet
resource "azurerm_subnet_network_security_group_association" "database_nsg" {
  subnet_id                 = azurerm_subnet.database_subnet.id
  network_security_group_id = module.database_nsg.nsg_id
}

# Create Staging Load Balancer Subnet
module "staging_lb_subnet" {
  source = "./modules/subnet"

  sub_name             = var.staging_lb_subnet_name
  resource_group_name  = var.rgname
  virtual_network_name = module.network.vnet_name
  address_prefix       = var.staging_lb_subnet_cidr
  service_endpoints    = var.staging_lb_service_endpoints
}

# NSG association for staging LB subnet
resource "azurerm_subnet_network_security_group_association" "staging_lb_nsg" {
  subnet_id                 = module.staging_lb_subnet.subnet_id
  network_security_group_id = module.staging_lb_nsg.nsg_id
}

# Create Production Load Balancer Subnet
module "production_lb_subnet" {
  source = "./modules/subnet"

  sub_name             = var.production_lb_subnet_name
  resource_group_name  = var.rgname
  virtual_network_name = module.network.vnet_name
  address_prefix       = var.production_lb_subnet_cidr
  service_endpoints    = var.production_lb_service_endpoints
}

# NSG association for production LB subnet
resource "azurerm_subnet_network_security_group_association" "production_lb_nsg" {
  subnet_id                 = module.production_lb_subnet.subnet_id
  network_security_group_id = module.production_lb_nsg.nsg_id
}

# Add a delay to ensure network is ready before creating Key Vault
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

# Add random suffix for unique Key Vault name
resource "random_id" "kv_suffix" {
  byte_length = 2
}

# Create Azure Key Vault for secrets management
module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = "aks-vault${random_id.kv_suffix.hex}"
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id
  environment                 = var.environment
}

# Add Key Vault RBAC role assignment for Service Principal
resource "azurerm_role_assignment" "keyvault_secrets_officer" {
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = module.ServicePrincipal.service_principal_object_id
}

# Create Azure Kubernetes Service
module "aks" {
  source                 = "./modules/aks/"
  aks_cluster_name       = var.aks_cluster_name
  aks_subnet_id          = module.network.aks_subnet_id
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.rgname
  environment            = var.environment
  system                 = var.system
  
  # Network configuration
  private_cluster_enabled = var.private_cluster_enabled
  node_count             = var.node_count
  service_cidr           = var.service_cidr
  dns_service_ip         = var.dns_service_ip
}

# Save kubeconfig locally for kubectl access
resource "local_file" "kubeconfig" {
  filename   = "./kubeconfig"
  content    = module.aks.config
}

# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgresql_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.rgname
}

# Private DNS Zone Virtual Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_dns_link" {
  name                  = "${var.postgresql_server_name}-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns.name
  virtual_network_id    = module.network.vnet_id
  resource_group_name   = var.rgname
}

# COMMENTED OUT: PostgreSQL Database with Private Network Access
/*
module "postgresql" {
  source = "./modules/postgresql"

  server_name          = var.postgresql_server_name
  resource_group_name  = var.rgname
  location            = var.location
  administrator_login = var.postgresql_admin_login
  administrator_password = var.postgresql_admin_password

  # Network configuration - PRIVATE ACCESS
  delegated_subnet_id    = azurerm_subnet.database_subnet.id
  virtual_network_id     = module.network.vnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.postgresql_dns.id
  high_availability_mode = "Disabled"

  # Database configuration
  postgres_version = var.postgresql_version
  sku_name         = var.postgresql_sku
  storage_mb       = var.postgresql_storage_mb
  databases        = var.postgresql_databases
  backup_retention_days = var.postgresql_backup_retention

  # Server configurations
  server_configurations = var.postgresql_configurations

  tags = {
    environment = var.environment
    project     = "APIM-aks"
    purpose     = "database"
  }
}
*/

# COMMENTED OUT: Bastion VM in dedicated bastion subnet
/*
module "bastion" {
  source              = "./modules/bastion"
  Bastion_prefix              = "${var.Bastion_prefix}-jumpbox"
  location            = var.location
  resource_group_name = var.rgname
  subnet_id           = module.bastion_subnet.subnet_id  # Use bastion subnet
  admin_username      = var.bastion_admin_username
  ssh_public_key_path = var.ssh_public_key
  vm_size             = var.bastion_vm_size
  allowed_ssh_ips     = var.allowed_ssh_cidr

  tags = {
    environment = var.environment
    project     = "APIM-aks"
    role        = "bastion"
  }
}
*/

# COMMENTED OUT: Bastion Network Security Group
/*
module "bastion_nsg" {
  source = "./modules/nsg"

  nsg_name            = "${var.Bastion_prefix}-bastion-nsg"
  location            = var.location
  resource_group_name = var.rgname
  security_rules      = local.bastion_security_rules
  
  tags = {
    environment = var.environment
    purpose     = "bastion"
  }
}
*/

# COMMENTED OUT: Bastion Subnet
/*
module "bastion_subnet" {
  source = "./modules/subnet"

  sub_name             = "${var.Bastion_prefix}-bastion-subnet"
  resource_group_name  = var.rgname
  virtual_network_name = module.network.vnet_name
  address_prefix       = var.bastion_subnet_cidr
  service_endpoints    = []  # No service endpoints needed for bastion
}
*/

# COMMENTED OUT: NSG association for bastion subnet
/*
resource "azurerm_subnet_network_security_group_association" "bastion_nsg" {
  subnet_id                 = module.bastion_subnet.subnet_id
  network_security_group_id = module.bastion_nsg.nsg_id
}
*/

# COMMENTED OUT: DNS A Record for PostgreSQL with known IP
/*
resource "azurerm_private_dns_a_record" "postgresql" {
  name                = var.postgresql_server_name
  zone_name           = azurerm_private_dns_zone.postgresql_dns.name
  resource_group_name = var.rgname
  ttl                 = 300
  records             = ["172.25.11.4"]  # The IP we found earlier
}
*/

# Create Azure Container Registry
module "acr" {
  source = "./modules/acr"

  acr_name          = var.acr_name
  resource_group_name = var.rgname
  location          = var.location
  sku               = var.acr_sku
  admin_enabled     = var.acr_admin_enabled

  # Use private endpoint for secure access
  create_private_endpoint    = var.acr_private_endpoint_enabled
  private_endpoint_subnet_id = module.network.private_endpoints_subnet_id

  tags = {
    environment = var.environment
    project     = "APIM-aks"
    purpose     = "container-registry"
  }
}

# Grant AKS service principal AcrPull access to ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.ServicePrincipal.service_principal_object_id
}

# Grant AKS service principal AcrPush access to ACR
resource "azurerm_role_assignment" "acr_push" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPush"
  principal_id         = module.ServicePrincipal.service_principal_object_id
}
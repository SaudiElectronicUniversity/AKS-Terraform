# ==============================================================================
# BASIC CONFIGURATION
# ==============================================================================

# Resource Group Configuration
rgname     = "APIM-AKS-RG"                                           # Main resource group name
location   = "West Europe"                                           # Azure region for all resources

# Core Infrastructure Names
vnet_name               = "SEU-Vnet"                                # Virtual Network name
service_principal_name  = "AKS-SP"                                  # Service Principal for AKS
aks_cluster_name        = "SEU-APIM-AKS"                            # AKS cluster name
keyvault_name           = "SEU-APIM-Vault"                          # Key Vault name

# Environment Configuration
system      = "APIM"                                                 # System identifier
environment = "production"                                           # Environment: production/staging
subscription_id = "37ba4f99-09d8-4c66-8fd1-ec1dbf842d09"            # Azure Subscription ID

# ==============================================================================
# NETWORK CONFIGURATION
# ==============================================================================

# Naming Prefixes
prefix        = "seu"                                                # Resource naming prefix
Bastion_prefix = "Test"                                              # Bastion resource prefix

# Virtual Network Configuration
vnet_address_space = "172.25.0.0/16"                                # Main VNet address space

# Subnet CIDR Ranges
aks_subnet_cidr                 = "172.25.0.0/21"                   # AKS nodes subnet
private_endpoints_subnet_cidr   = "172.25.8.0/24"                   # Private endpoints subnet
bastion_subnet_cidr             = "172.25.12.0/24"                  # Bastion/jumpbox subnet

# ==============================================================================
# SECURITY & ACCESS CONFIGURATION
# ==============================================================================

# SSH Configuration
ssh_public_key = "~/.ssh/aks_id_ed25519.pub"                        # Path to SSH public key

# Bastion VM Configuration
bastion_admin_username = "adminuser"                                # Bastion VM admin username
bastion_vm_size       = "Standard_B1s"                              # Bastion VM size
allowed_ssh_cidr      = "0.0.0.0/0"                                 # Allowed SSH source IPs (0.0.0.0/0 = any)

# ==============================================================================
# AKS CLUSTER CONFIGURATION
# ==============================================================================

# AKS Network Settings
private_cluster_enabled = true                                       # Enable private AKS cluster
node_count            = 2                                            # Number of AKS nodes
service_cidr          = "10.1.0.0/16"                               # K8s service CIDR range
dns_service_ip        = "10.1.0.10"                                 # K8s internal DNS service IP

# ==============================================================================
# DATABASE SUBNET CONFIGURATION
# ==============================================================================

db_subnet_name        = "db-subnet"                                  # Database subnet name
db_subnet_address     = "172.25.11.0/24"                            # Database subnet CIDR
db_service_endpoints  = [                                            # Service endpoints for database subnet
  "Microsoft.Sql",
  "Microsoft.Storage", 
  "Microsoft.KeyVault"
]

# ==============================================================================
# LOAD BALANCER SUBNET CONFIGURATIONS
# ==============================================================================

# Staging Load Balancer Subnet
staging_lb_subnet_name    = "staging-subnet"                         # Staging LB subnet name
staging_lb_subnet_cidr    = "172.25.9.0/24"                         # Staging LB subnet CIDR
staging_lb_service_endpoints = ["Microsoft.Storage"]                 # Staging service endpoints

# Production Load Balancer Subnet  
production_lb_subnet_name    = "production-subnet"                   # Production LB subnet name
production_lb_subnet_cidr    = "172.25.10.0/24"                     # Production LB subnet CIDR
production_lb_service_endpoints = ["Microsoft.Storage"]              # Production service endpoints

# ==============================================================================
# CONTAINER REGISTRY CONFIGURATION
# ==============================================================================

acr_name                    = "apimacr001"                           # Azure Container Registry name
acr_sku                     = "Standard"                             # ACR SKU (Basic/Standard/Premium)
acr_admin_enabled           = false                                  # Enable ACR admin account
acr_private_endpoint_enabled = false                                    # Enable private endpoint for ACR

# ==============================================================================
# POSTGRESQL DATABASE CONFIGURATION
# ==============================================================================

# postgresql_server_name    = "pg-apim-aks-db01"                      # PostgreSQL server name
# postgresql_admin_login    = "seu_tools_user"                        # Database admin username
# postgresql_admin_password = "Seupass123"                            # Database admin password
# postgresql_version        = "13"                                    # PostgreSQL version
# postgresql_sku            = "GP_Standard_D2ds_v5"                   # PostgreSQL SKU (General Purpose)
# postgresql_storage_mb     = 32768                                   # Database storage in MB (32GB)
# postgresql_databases      = ["seu_tools_db"]                        # Databases to create
# postgresql_backup_retention = 7                                     # Backup retention in days
# postgresql_ha_mode        = "Disabled"                              # High Availability mode
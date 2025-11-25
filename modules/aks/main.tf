# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false  
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"           
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  
  # Enable private cluster
  private_cluster_enabled = var.private_cluster_enabled
  
  # Add OIDC issuer support (for workload identity)
  oidc_issuer_enabled = true

  # Add Key Vault Secrets Provider (for CSI driver)
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  default_node_pool {
    name           = "defaultpool"
    vm_size        = "Standard_D4s_v3"
    node_count     = var.node_count
    vnet_subnet_id = var.aks_subnet_id
    os_disk_size_gb = 30
    type           = "VirtualMachineScaleSets"
    
    # Corrected temporary name - 12 characters or less
    temporary_name_for_rotation = "temprotation"
    
    # Add upgrade settings for safe node pool updates
    upgrade_settings {
      max_surge = "10%"
    }
    
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
    }
    
    tags = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
      "System"        = var.system
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  # Network profile with the new variables
  network_profile {
    network_plugin    = "azure"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    load_balancer_sku = "standard"
  }

  tags = {
    environment = var.environment
    project     = "aks-cluster"
  }
}
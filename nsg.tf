# Network Security Group Rules Configuration
locals {
  # Database Security Rules - DEFAULT ONLY (No custom rules)
  db_security_rules = []

  # Bastion Security Rules - SSH ONLY from any source
  bastion_security_rules = [
    {
      name                       = "AllowSSH-Any"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  # Staging Load Balancer Security Rules - DEFAULT ONLY
  staging_lb_security_rules = []

  # Production Load Balancer Security Rules - DEFAULT ONLY  
  production_lb_security_rules = []

  # AKS Subnet Security Rules - DEFAULT ONLY
  aks_security_rules = []
}
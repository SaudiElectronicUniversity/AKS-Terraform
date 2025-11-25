# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]

  tags = var.tags
}

# AKS Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

# Private Endpoints Subnet
resource "azurerm_subnet" "private_endpoints_subnet" {
  name                 = "${var.prefix}-private-ep-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_endpoints_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}
resource "azurerm_subnet" "subnet" {
  name                 = var.sub_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.address_prefix]

  service_endpoints = var.service_endpoints

  # Add service delegation
  dynamic "delegation" {
    for_each = var.service_delegation != null ? [1] : []
    content {
      name = "delegation"
      service_delegation {
        name    = var.service_delegation
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count = var.network_security_group_id != null ? 1 : 0

  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = var.network_security_group_id
}
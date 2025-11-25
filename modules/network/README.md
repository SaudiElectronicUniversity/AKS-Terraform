# Azure Subnet Module

A simple, reusable module for creating Azure subnets.

## Usage

```hcl
module "my_subnet" {
  source = "./modules/subnet"

  name                 = "my-subnet"
  resource_group_name  = "my-rg"
  virtual_network_name = "my-vnet"
  address_prefix       = "10.0.1.0/24"
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}
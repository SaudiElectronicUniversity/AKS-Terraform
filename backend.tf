terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"               # From bootstrap
    storage_account_name = "tftstateseu"              # From bootstrap output
    container_name       = "tfstate-seu"              # From bootstrap
    key                  = "aks-terraform.tfstate"    # State file name
  }
}


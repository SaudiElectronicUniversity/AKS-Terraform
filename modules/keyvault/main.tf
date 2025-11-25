data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  enable_rbac_authorization   = true
  public_network_access_enabled = true

  # Remove network_acls temporarily to avoid issues
  # network_acls {
  #   default_action = "Allow"
  #   bypass         = "AzureServices"
  # }

  tags = {
    environment = var.environment
  }

  timeouts {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }

  lifecycle {
    # Completely ignore contact and network_acls to prevent refresh issues
    ignore_changes = [
      contact,
      network_acls,
      access_policy
    ]
  }
}
resource azurerm_key_vault vault {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = [var.my_ip_address]
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  tags = var.tags
}

# Create VM managed identity
resource azurerm_user_assigned_identity vm_identity {
  name                = "vm-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Access policy for the VM's managed identity
resource azurerm_key_vault_access_policy vm {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.vm_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# Admin Username Secret
resource azurerm_key_vault_secret admin_username {
  name         = var.admin_username_secret_name
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.vault.id
} 
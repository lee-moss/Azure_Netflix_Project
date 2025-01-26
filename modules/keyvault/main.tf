resource random_string random {
  length  = 8
  special = false
  upper   = false
}

resource azurerm_key_vault keyvault {
  name                = "netflix-kv-${random_string.random.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"
  enable_rbac_authorization = false
  network_acls {
    default_action             = "Deny"
    ip_rules                   = [var.my_ip_address]
    virtual_network_subnet_ids = var.allowed_subnet_ids
    bypass                     = "AzureServices"
  }

  tags = var.tags
}

# Access policy for the current user/service principal
resource azurerm_key_vault_access_policy admin {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = var.tenant_id
  object_id    = var.admin_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover"
  ]
}

# Access policy for the VM's managed identity
resource azurerm_key_vault_access_policy vm {
  count = var.vm_identity_object_id != null ? 1 : 0

  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = var.tenant_id
  object_id    = var.vm_identity_object_id

  secret_permissions = [
    "Get", "List"
  ]
}

# Core secrets
resource azurerm_key_vault_secret admin_username {
  name         = "vm-admin-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource azurerm_key_vault_secret netflix_secret {
  name         = "NetflixSecret"
  value        = var.netflix_secret_value
  key_vault_id = azurerm_key_vault.keyvault.id
} 
resource azurerm_key_vault vault {
  name                         = "${var.key_vault_name}-${random_string.random.result}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  tenant_id                    = var.tenant_id
  sku_name                     = "standard"
  enable_rbac_authorization    = false 

  enabled_for_disk_encryption  = true
  purge_protection_enabled     = false
  soft_delete_retention_days   = 7

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = [var.my_ip_address]
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  tags = var.tags
}

# Access policy for admin
resource azurerm_key_vault_access_policy admin {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = var.tenant_id
  object_id    = var.admin_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover"
  ]
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

# TMDB Secrets
resource azurerm_key_vault_secret tmdb_api_key {
  name         = "tmdb-api-key"
  value        = var.tmdb_api_key
  key_vault_id = azurerm_key_vault.vault.id
}

resource azurerm_key_vault_secret tmdb_access_token {
  name         = "tmdb-access-token"
  value        = var.tmdb_access_token
  key_vault_id = azurerm_key_vault.vault.id
}

# Create ACR (Azure Container Registry)
resource azurerm_container_registry acr {
  name                = "netflixacr${random_string.random.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"  
  admin_enabled       = false      

  public_network_access_enabled = false  

  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = var.my_ip_address
    }
  }

  tags = var.tags
}

# Grant AcrPull role to VM's managed identity
resource azurerm_role_assignment vm_acr_pull {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.vm_identity.principal_id
} 
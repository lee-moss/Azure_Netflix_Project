resource random_string random {
  length  = 8
  special = false
  upper   = false
}

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
    default_action             = "Allow"  # Temporarily allow all access during initial setup
    ip_rules                   = []       # Remove IP restrictions during initial setup
    virtual_network_subnet_ids = []       # Remove subnet restrictions during initial setup
  }

  tags = var.tags
}

# Access policy for admin - Create this first
resource azurerm_key_vault_access_policy admin {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = var.tenant_id
  object_id    = var.admin_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover"
  ]
}

# Access policy for Azure DevOps Service Principal - Create this second
resource azurerm_key_vault_access_policy devops_sp {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = var.tenant_id
  object_id    = var.devops_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"
  ]

  # Ensure this is created after the admin policy
  depends_on = [
    azurerm_key_vault_access_policy.admin
  ]
}

# Create VM managed identity
resource azurerm_user_assigned_identity vm_identity {
  name                = "vm-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Access policy for the VM's managed identity - Create this third
resource azurerm_key_vault_access_policy vm {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.vm_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  # Ensure this is created after the DevOps policy
  depends_on = [
    azurerm_key_vault_access_policy.devops_sp
  ]
}

# Admin Username Secret - Create after access policies
resource azurerm_key_vault_secret admin_username {
  name         = var.admin_username_secret_name
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.vault.id

  depends_on = [
    azurerm_key_vault_access_policy.admin,
    azurerm_key_vault_access_policy.devops_sp
  ]
}

# TMDB Secrets - Create after access policies
resource azurerm_key_vault_secret tmdb_api_key {
  name         = "tmdb-api-key"
  value        = var.tmdb_api_key
  key_vault_id = azurerm_key_vault.vault.id

  depends_on = [
    azurerm_key_vault_access_policy.admin,
    azurerm_key_vault_access_policy.devops_sp
  ]
}

resource azurerm_key_vault_secret tmdb_access_token {
  name         = "tmdb-access-token"
  value        = var.tmdb_access_token
  key_vault_id = azurerm_key_vault.vault.id

  depends_on = [
    azurerm_key_vault_access_policy.admin,
    azurerm_key_vault_access_policy.devops_sp
  ]
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
data azurerm_client_config current {}

# Only use random string for ACR (where it's required)
resource random_string random {
  length  = 8
  special = false
  upper   = false
}

resource azurerm_key_vault vault {
  name                         = var.key_vault_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  tenant_id                    = data.azurerm_client_config.current.tenant_id
  sku_name                     = "standard"
  enable_rbac_authorization    = false 

  enabled_for_disk_encryption  = true
  purge_protection_enabled     = false
  soft_delete_retention_days   = 7

  # Grant initial access to the deployment service principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Import"
    ]
  }

  # Grant access to the DevOps service principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.devops_object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Import"
    ]
  }

  # Grant access to the admin
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.admin_object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Import"
    ]
  }

  # Grant access to the VM managed identity
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.vm_identity.principal_id

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get", "List"
    ]

    certificate_permissions = [
      "Get", "List"
    ]
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"  # Allow during initial setup
    ip_rules                   = []
    virtual_network_subnet_ids = []
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
  name                = "netflixacr${lower(random_string.random.result)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"  
  admin_enabled       = false      

  public_network_access_enabled = true  # Allow during initial setup

  tags = var.tags
}

# Grant AcrPull role to VM's managed identity
resource azurerm_role_assignment vm_acr_pull {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.vm_identity.principal_id
} 
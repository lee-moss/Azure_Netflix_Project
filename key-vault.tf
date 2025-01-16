resource azurerm_key_vault_secret NetflixSecret {
  name         = "NetflixSecret"
  value        = "your-secret-value"
  key_vault_id = azurerm_key_vault.netflix.id
}

resource random_string random {
  length  = 8
  special = false
  upper   = false
}

resource azurerm_key_vault netflix {
  name                = "netflix-kv-${random_string.random.result}"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }
}

resource azurerm_key_vault_secret admin_username {
  name         = "vm-admin-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.netflix.id
}

resource azurerm_key_vault_secret admin_password {
  name         = "vm-password"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.netflix.id
}
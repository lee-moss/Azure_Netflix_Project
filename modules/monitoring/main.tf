# Storage Account for Monitoring Data
resource azurerm_storage_account monitoring {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Container for Prometheus Data
resource azurerm_storage_container prometheus {
  name                  = "prometheus-data"
  storage_account_name  = azurerm_storage_account.monitoring.name
  container_access_type = "private"
}

# Container for Grafana Data
resource azurerm_storage_container grafana {
  name                  = "grafana-data"
  storage_account_name  = azurerm_storage_account.monitoring.name
  container_access_type = "private"
}

# Key Vault Secrets for Monitoring
resource azurerm_key_vault_secret prometheus_storage {
  name         = "prometheus-storage-key"
  value        = azurerm_storage_account.monitoring.primary_access_key
  key_vault_id = var.key_vault_id
}

resource azurerm_key_vault_secret grafana_storage {
  name         = "grafana-storage-key"
  value        = azurerm_storage_account.monitoring.primary_access_key
  key_vault_id = var.key_vault_id
}

# Role Assignment for VM to Access Storage
resource azurerm_role_assignment vm_storage {
  scope                = azurerm_storage_account.monitoring.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.vm_identity_principal_id
} 
output key_vault_id {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.vault.id
}

output key_vault_uri {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.vault.vault_uri
}

output acr_id {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output acr_login_server {
  description = "Login server for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output admin_username_secret_id {
  description = "ID of the admin username secret"
  value       = azurerm_key_vault_secret.admin_username.id
}

output admin_username {
  description = "Admin username stored in Key Vault"
  value       = var.admin_username
  sensitive   = true
}

output vm_identity_id {
  description = "ID of the VM's managed identity"
  value       = azurerm_user_assigned_identity.vm_identity.id
}

output vm_identity_principal_id {
  description = "Principal ID of the VM's managed identity"
  value       = azurerm_user_assigned_identity.vm_identity.principal_id
} 
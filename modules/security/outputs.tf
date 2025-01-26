output key_vault_id {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.keyvault.id
}

output key_vault_uri {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.vault.vault_uri
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
output key_vault_id {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.vault.id
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
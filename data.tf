data "azurerm_key_vault" "netflix" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "admin_username" {
  name         = var.admin_username_secret
  key_vault_id = data.azurerm_key_vault.netflix.id
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_secret
  key_vault_id = data.azurerm_key_vault.netflix.id
}

data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "netflix" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

# Required Variables
variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

variable location {
  description = "Azure region location"
  type        = string
}

variable storage_account_name {
  description = "Name of the storage account for monitoring data"
  type        = string
}

variable key_vault_id {
  description = "ID of the Key Vault to store secrets"
  type        = string
}

variable vm_identity_principal_id {
  description = "Principal ID of the VM's managed identity"
  type        = string
}

# Optional Variables
variable tags {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 
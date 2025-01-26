variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

variable location {
  description = "Azure region location"
  type        = string
}

variable key_vault_name {
  description = "Name of the Key Vault"
  type        = string
}

variable tenant_id {
  description = "Azure AD tenant ID"
  type        = string
}

variable my_ip_address {
  description = "IP address to allow access to Key Vault"
  type        = string
}

variable allowed_subnet_ids {
  description = "List of subnet IDs to allow access to Key Vault"
  type        = list(string)
  default     = []
}

variable admin_username {
  description = "Admin username to store in Key Vault"
  type        = string
}

variable admin_username_secret_name {
  description = "Name of the admin username secret in Key Vault"
  type        = string
  default     = "vm-admin-username"
}

variable tags {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 
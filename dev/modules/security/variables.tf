variable admin_object_id {
  description = "Object ID of the admin user/service principal"
  type        = string
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

variable allowed_subnet_ids {
  description = "List of subnet IDs to allow access to Key Vault"
  type        = list(string)
  default     = []
}

variable devops_object_id {
  description = "Object ID of the Azure DevOps service principal"
  type        = string
}

variable key_vault_name {
  description = "Name of the Key Vault"
  type        = string
}

variable location {
  description = "Azure region location"
  type        = string
}

variable my_ip_address {
  description = "IP address to allow access to Key Vault"
  type        = string
}

variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

variable tags {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable tenant_id {
  description = "Azure AD tenant ID"
  type        = string
}

variable tmdb_access_token {
  description = "Read Access Token for The Movie Database (TMDB)"
  type        = string
  sensitive   = true
}

variable tmdb_api_key {
  description = "API Key for The Movie Database (TMDB)"
  type        = string
  sensitive   = true
} 
# Required Variables
variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

variable location {
  description = "Azure region location"
  type        = string
}

variable tenant_id {
  description = "Azure AD tenant ID"
  type        = string
}

variable admin_object_id {
  description = "Object ID of the admin user/service principal"
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

variable vm_identity_object_id {
  description = "Object ID of the VM's managed identity"
  type        = string
  default     = null
}

variable admin_username {
  description = "Admin username for the VM"
  type        = string
}

# TMDB API Variables
variable tmdb_api_key {
  description = "API Key for The Movie Database (TMDB)"
  type        = string
  sensitive   = true
}

variable tmdb_access_token {
  description = "Read Access Token for The Movie Database (TMDB)"
  type        = string
  sensitive   = true
}

variable tags {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 
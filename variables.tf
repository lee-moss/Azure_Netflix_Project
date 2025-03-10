# Admin Variables
variable admin_password {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable admin_password_secret {
  description = "Name of the admin password secret in Key Vault"
  type        = string
  default     = "vm-password"
}

variable admin_username {
  description = "Admin username for the virtual machine"
  type        = string
}

variable admin_username_secret {
  description = "Name of the admin username secret in Key Vault"
  type        = string
  default     = "vm-admin-username"
}

# DevOps Variables
variable devops_object_id {
  description = "Object ID of the Azure DevOps service principal"
  type        = string
}

# Key Vault Variables
variable key_vault_name {
  description = "Name of the Key Vault"
  type        = string
}

variable key_vault_rg {
  description = "Resource group name for the Key Vault"
  type        = string
}

# Network Variables
variable my_ip_address {
  description = "Your IP address for SSH access"
  type        = string
}

# TMDB API Variables
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
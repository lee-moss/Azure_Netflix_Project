variable admin_password {
  type = string
}

variable admin_username {
  type = string
}

variable key_vault_name {
  type = string
}

variable key_vault_rg {
  type = string
}

variable admin_username_secret {
  type = string
  default = "vm-admin-username"
}

variable admin_password_secret {
  type = string
  default = "vm-password"
}

variable my_ip_address {
  description = "Your IP address for SSH access"
  type        = string
}

variable netflix_secret_value {
  description = "Value for the Netflix secret"
  type        = string
  sensitive   = true
}
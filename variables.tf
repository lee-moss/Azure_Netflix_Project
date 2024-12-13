variable "admin_password" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "key_vault_rg" {
  type = string
}

variable "admin_username_secret" {
  type = string
  default = "vm-admin-username"
}

variable "admin_password_secret" {
  type = string
  default = "vm-password"
}
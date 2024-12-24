variable "admin_password" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "key_vault_rg" {
  type = string
}

variable "vm-admin-username" {
  type = string
  default = "vm-admin-username"
}

variable "vm-password" {
  type = string
  default = "vm-password"
}
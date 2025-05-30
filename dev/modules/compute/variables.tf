# Authentication
variable admin_username {
  description = "Admin username for the virtual machine"
  type        = string
}

variable environment {  
  description = "Environment, eg dev, nonprod, prod"
  type        = string
}

# VM Configuration
variable vm_name {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm1"
}

variable vm_size {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_F2"
}

variable vm_identity_id {
  description = "ID of the VM's managed identity"
  type        = string
}

# Storage Configuration
variable os_disk_type {
  description = "Type of OS disk"
  type        = string
  default     = "Standard_LRS"
}

# Image Configuration
variable image_publisher {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable image_offer {
  description = "Offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable image_sku {
  description = "SKU of the VM image"
  type        = string
  default     = "22_04-lts"
}

variable image_version {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

# Network Configuration
variable subnet_id {
  description = "ID of the subnet to place the VM in"
  type        = string
}

# Security Configuration
variable key_vault_id {
  description = "ID of the Key Vault to store secrets"
  type        = string
}

# Resource Information
variable location {
  description = "Azure region location"
  type        = string
}

variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

# Tags
variable tags {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
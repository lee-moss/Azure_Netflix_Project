# Core Network Configuration
variable address_space {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable vnet_name {
  description = "Name of the virtual network"
  type        = string
  default     = "netflix-network"
}

# Subnet Configuration
variable aks_subnet_prefix {
  description = "Address prefix for AKS subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable db_subnet_prefix {
  description = "Address prefix for database subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable management_subnet_prefix {
  description = "Address prefix for management subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable pe_subnet_prefix {
  description = "Address prefix for private endpoints subnet"
  type        = string
  default     = "10.0.4.0/24"
}

# NAT Gateway Configuration
variable nat_gateway_name {
  description = "Name of the NAT gateway"
  type        = string
  default     = "nat-gateway"
}

variable nat_pip_name {
  description = "Name of the NAT gateway public IP"
  type        = string
  default     = "PublicIp1"
}

# Security Configuration
variable nsg_name {
  description = "Name of the network security group"
  type        = string
  default     = "nsg-1"
}

variable my_ip_address {
  description = "Your IP address for SSH access"
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
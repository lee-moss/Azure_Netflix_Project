# Required Variables
variable resource_group_name {
  description = "Name of the resource group"
  type        = string
}

variable location {
  description = "Azure region location"
  type        = string
}

variable cluster_name {
  description = "Name of the AKS cluster"
  type        = string
}

variable dns_prefix {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable subnet_id {
  description = "ID of the subnet for AKS nodes"
  type        = string
}

variable acr_id {
  description = "ID of the Azure Container Registry"
  type        = string
}

# Optional Variables
variable kubernetes_version {
  description = "Version of Kubernetes to use"
  type        = string
  default     = "1.26.3"
}

variable node_count {
  description = "Initial number of nodes in the default pool"
  type        = number
  default     = 2
}

variable node_size {
  description = "Size of the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable min_node_count {
  description = "Minimum number of nodes for auto-scaling"
  type        = number
  default     = 1
}

variable max_node_count {
  description = "Maximum number of nodes for auto-scaling"
  type        = number
  default     = 5
}

variable tags {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 
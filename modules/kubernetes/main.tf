resource azurerm_kubernetes_cluster aks {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.node_size
    vnet_subnet_id  = var.subnet_id
    min_count       = var.min_node_count
    max_count       = var.max_node_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    dns_service_ip = "172.16.0.10"
    service_cidr   = "172.16.0.0/16"
  }

  tags = var.tags
}

# Role assignment for AKS to pull images from ACR
resource azurerm_role_assignment aks_acr_pull {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
} 
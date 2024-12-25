resource azurerm_kubernetes_cluster aks {
  name                = "aks1"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name
  dns_prefix          = "netflix-aks"

  default_node_pool {
    name           = "default"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    node_count     = 2
    vm_size        = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "172.16.0.10"
    service_cidr       = "172.16.0.0/16"
  }
}
resource azurerm_kubernetes_cluster aks {
  name                = "aks1"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name

  default_node_pool {
    name           = "default"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    node_count     = 1
    vm_size        = "Standard_D2_v2"
  }
}
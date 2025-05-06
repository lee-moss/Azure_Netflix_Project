output vnet_id {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output vnet_name {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output aks_subnet_id {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output management_subnet_id {
  description = "ID of the management subnet"
  value       = azurerm_subnet.management.id
}

output db_subnet_id {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db.id
}

output pe_subnet_id {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output nsg_id {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.nsg.id
}

output nat_gateway_id {
  description = "ID of the NAT gateway"
  value       = azurerm_nat_gateway.nat.id
}

output nat_public_ip {
  description = "Public IP of the NAT gateway"
  value       = azurerm_public_ip.nat_pip.ip_address
} 
resource azurerm_resource_group netflix {
  name     = "Azure-Netflix-Clone"
  location = "UK West"
}

resource azurerm_network_security_group nsg {
  name                = "nsg-1"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name

  dynamic "security_rule" {
    for_each = local.security_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range         = security_rule.value.source_port_range
      destination_port_range    = security_rule.value.destination_port_range
      source_address_prefix     = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource azurerm_virtual_network vnet {
  name                = "netflix-network"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name
  address_space       = ["10.0.0.0/16"]
}

resource azurerm_subnet aks_subnet {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.netflix.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource azurerm_subnet management_subnet {
  name                 = "management-subnet"
  resource_group_name  = azurerm_resource_group.netflix.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource azurerm_subnet db_subnet {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.netflix.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource azurerm_subnet pe_subnet {
  name                 = "private-endpoints-subnet"
  resource_group_name  = azurerm_resource_group.netflix.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource azurerm_network_interface nic {
  name                = "vm1-nic"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.management_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource azurerm_linux_virtual_machine vm1 {
  name                = "vm1"
  resource_group_name = azurerm_resource_group.netflix.name
  location            = azurerm_resource_group.netflix.location
  size                = "Standard_F2"
  admin_username      = data.azurerm_key_vault_secret.admin_username.value
  admin_password      = data.azurerm_key_vault_secret.admin_password.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
    

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource azurerm_subnet_network_security_group_association management_nsg {
  subnet_id                 = azurerm_subnet.management_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource azurerm_subnet_network_security_group_association aks_nsg {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource azurerm_subnet_network_security_group_association db_nsg {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
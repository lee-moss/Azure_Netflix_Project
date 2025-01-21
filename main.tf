resource azurerm_resource_group netflix {
  name     = "Azure-Netflix-Clone"
  location = "UK West"
}

// Storage
resource azurerm_storage_account tfstate {
  name                     = "tfstatest"
  resource_group_name      = azurerm_resource_group.netflix.name
  location                 = azurerm_resource_group.netflix.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource azurerm_storage_container tfstate-con {
  name                  = "tfstate"
  storage_account_name    = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

// Networking
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

resource azurerm_public_ip netflix_pip {
  name                = "PublicIp1"
  resource_group_name = azurerm_resource_group.netflix.name
  location            = azurerm_resource_group.netflix.location
  allocation_method   = "Static"
}

resource azurerm_nat_gateway netflix_nat {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.netflix.location
  resource_group_name     = azurerm_resource_group.netflix.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

// Security
resource azurerm_network_security_group nsg {
  name                = "nsg-1"
  location            = azurerm_resource_group.netflix.location
  resource_group_name = azurerm_resource_group.netflix.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

// Compute Supporting Resources
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

// Compute
resource azurerm_linux_virtual_machine vm1 {
  name                            = "vm1"
  resource_group_name             = azurerm_resource_group.netflix.name
  location                        = azurerm_resource_group.netflix.location
  size                            = "Standard_F2"
  admin_username                  = azurerm_key_vault_secret.admin_username.value
  admin_password                  = azurerm_key_vault_secret.admin_password.value
  disable_password_authentication = false
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

// Associations
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

resource azurerm_nat_gateway_public_ip_association pip_nat {
  nat_gateway_id       = azurerm_nat_gateway.netflix_nat.id
  public_ip_address_id = azurerm_public_ip.netflix_pip.id
}

resource azurerm_subnet_nat_gateway_association aks_nat_ass {
  subnet_id      = azurerm_subnet.aks_subnet.id
  nat_gateway_id = azurerm_nat_gateway.netflix_nat.id
}

resource azurerm_subnet_nat_gateway_association management_nat_ass {
  subnet_id      = azurerm_subnet.management_subnet.id
  nat_gateway_id = azurerm_nat_gateway.netflix_nat.id
}




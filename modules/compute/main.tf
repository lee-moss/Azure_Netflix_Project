# Network Interface
resource azurerm_network_interface nic {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Managed Identity
resource azurerm_user_assigned_identity vm_identity {
  name                = "${var.vm_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# SSH Key
resource tls_private_key ssh_key {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store SSH Key in Key Vault
resource azurerm_key_vault_secret ssh_private_key {
  name         = "${var.vm_name}-ssh-private-key"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = var.key_vault_id
}

# Virtual Machine
resource azurerm_linux_virtual_machine vm {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  custom_data                     = var.custom_data

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id]
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
} 
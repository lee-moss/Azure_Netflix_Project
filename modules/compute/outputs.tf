output vm_id {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output private_ip_address {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.nic.private_ip_address
}

output admin_username {
  description = "Admin username of the virtual machine"
  value       = var.admin_username
  sensitive   = true
}

output ssh_public_key {
  description = "Public key for SSH access"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output vm_public_ip {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}

output vm_public_ip_fqdn {
  description = "The FQDN of the virtual machine's public IP address"
  value       = azurerm_public_ip.vm_public_ip.fqdn
} 
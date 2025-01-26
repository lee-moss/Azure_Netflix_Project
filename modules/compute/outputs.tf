output vm_id {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output vm_identity_id {
  description = "ID of the VM's managed identity"
  value       = azurerm_user_assigned_identity.vm_identity.id
}

output private_ip_address {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.nic.private_ip_address
}

output ssh_public_key {
  description = "Public key for SSH access"
  value       = tls_private_key.ssh_key.public_key_openssh
}

output admin_username {
  description = "Admin username of the VM"
  value       = var.admin_username
} 
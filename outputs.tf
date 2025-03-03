output vm_public_ip {
  description = "The public IP address of the virtual machine"
  value       = module.compute.vm_public_ip
}

output vm_public_ip_fqdn {
  description = "The FQDN of the virtual machine's public IP address"
  value       = module.compute.vm_public_ip_fqdn
}

output vm_admin_username {
  description = "The admin username of the virtual machine"
  value       = var.admin_username
  sensitive   = true
} 
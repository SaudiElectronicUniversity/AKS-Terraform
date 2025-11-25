output "bastion_vm_id" {
  description = "Bastion VM ID"
  value       = azurerm_linux_virtual_machine.bastion.id
}

output "bastion_public_ip" {
  description = "Bastion public IP address"
  value       = azurerm_public_ip.bastion.ip_address
}

output "bastion_private_ip" {
  description = "Bastion private IP address"
  value       = azurerm_network_interface.bastion.private_ip_address
}

output "ssh_command" {
  description = "SSH command to connect to bastion"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.bastion.ip_address}"
}

# Add this output for the admin username
output "admin_username" {
  description = "Bastion admin username"
  value       = var.admin_username
}
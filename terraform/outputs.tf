# dans terraform/outputs.tf

output "preprod_vm_public_ip" {
  description = "Adresse IP publique de la VM de pré-production."
  value       = azurerm_public_ip.preprod_pip.ip_address
}

output "prod_vm_public_ip" {
  description = "Adresse IP publique de la VM de production."
  value       = azurerm_public_ip.prod_pip.ip_address
}

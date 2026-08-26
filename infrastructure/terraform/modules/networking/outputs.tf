output "vnet_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "aks_system_subnet_id" {
  description = "ID of the AKS system node subnet."
  value       = azurerm_subnet.aks_system.id
}

output "aks_workload_subnet_id" {
  description = "ID of the AKS workload subnet."
  value       = azurerm_subnet.aks_workload.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet."
  value       = azurerm_subnet.private_endpoints.id
}
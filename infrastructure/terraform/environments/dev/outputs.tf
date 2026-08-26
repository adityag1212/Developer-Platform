output "resource_group_name" {
  description = "Name of the platform resource group."
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "Resource ID of the platform resource group."
  value       = module.resource_group.id
}
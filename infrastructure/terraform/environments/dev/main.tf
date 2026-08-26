locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    environment = var.environment
    project     = var.project_name
    managed_by  = "terraform"
  }
}

module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source = "../../modules/networking"

  vnet_name               = "vnet-${local.name_prefix}"
  location                = var.location
  resource_group_name     = module.resource_group.name
  address_space           = var.vnet_address_space
  system_subnet           = var.aks_system_subnet
  workload_subnet         = var.aks_workload_subnet
  private_endpoint_subnet = var.private_endpoint_subnet
  tags                    = local.common_tags
}
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  role_based_access_control_enabled = true

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name                        = "system"
    vm_size                     = var.system_vm_size
    vnet_subnet_id              = var.system_subnet_id
    auto_scaling_enabled        = true
    min_count                   = var.system_min_count
    max_count                   = var.system_max_count
    only_critical_addons_enabled = true
    temporary_name_for_rotation = "systemtmp"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    network_policy      = "azure"
    load_balancer_sku   = "standard"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                  = "workload"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size        = var.workload_vm_size
  vnet_subnet_id = var.workload_subnet_id

  auto_scaling_enabled = true
  min_count             = var.workload_min_count
  max_count             = var.workload_max_count

  mode = "User"

  temporary_name_for_rotation = "worktmp"

  tags = var.tags
}
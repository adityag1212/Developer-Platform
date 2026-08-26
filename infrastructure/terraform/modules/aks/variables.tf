variable "cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for AKS."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "system_subnet_id" {
  description = "Subnet ID for the system node pool."
  type        = string
}

variable "workload_subnet_id" {
  description = "Subnet ID for the workload node pool."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version. Null allows AKS to select a supported version."
  type        = string
  default     = null
}

variable "system_vm_size" {
  description = "VM size for system nodes."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "workload_vm_size" {
  description = "VM size for workload nodes."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "system_min_count" {
  description = "Minimum system node count."
  type        = number
  default     = 1
}

variable "system_max_count" {
  description = "Maximum system node count."
  type        = number
  default     = 3
}

variable "workload_min_count" {
  description = "Minimum workload node count."
  type        = number
  default     = 1
}

variable "workload_max_count" {
  description = "Maximum workload node count."
  type        = number
  default     = 5
}

variable "pod_cidr" {
  description = "Pod CIDR used by Azure CNI Overlay."
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "Kubernetes service CIDR."
  type        = string
  default     = "10.10.0.0/16"
}

variable "dns_service_ip" {
  description = "Kubernetes DNS service IP."
  type        = string
  default     = "10.10.0.10"
}

variable "tags" {
  description = "Tags applied to AKS resources."
  type        = map(string)
  default     = {}
}
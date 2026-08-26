variable "project_name" {
  description = "Name of the platform project."
  type        = string

  default = "developer-platform"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "Central India"
}

variable "vnet_address_space" {
  description = "Address space assigned to the platform virtual network."
  type        = list(string)
}

variable "aks_system_subnet" {
  description = "CIDR range for AKS system nodes."
  type        = string
}

variable "aks_workload_subnet" {
  description = "CIDR range for AKS workloads."
  type        = string
}

variable "private_endpoint_subnet" {
  description = "CIDR range for Azure private endpoints."
  type        = string
}
variable "vnet_name" {
  description = "Name of the Azure virtual network."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual network."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "system_subnet" {
  description = "CIDR range for the AKS system node subnet."
  type        = string
}

variable "workload_subnet" {
  description = "CIDR range for the AKS workload subnet."
  type        = string
}

variable "private_endpoint_subnet" {
  description = "CIDR range for private endpoints."
  type        = string
}

variable "tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
  default     = {}
}
variable "name" {
  description = "Name of the Azure resource group."
  type        = string
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string
}

variable "tags" {
  description = "Common tags applied to the resource group."
  type        = map(string)
  default     = {}
}
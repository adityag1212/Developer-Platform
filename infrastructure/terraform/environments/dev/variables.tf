variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "Central India"
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Name of the platform project."
  type        = string
  default     = "developer-platform"
}
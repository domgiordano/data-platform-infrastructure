# modules/compute/data-factory/variables.tf

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "managed_identity_id" {
  description = "ID of the user-assigned managed identity"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Data Factory"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account for private endpoints"
  type        = string
  default     = ""
}

variable "storage_account_name" {
  description = "Name of the storage account for linked services"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "ID of the Key Vault for linked service"
  type        = string
  default     = ""
}

# GitHub Configuration
variable "github_account_name" {
  description = "GitHub account/organization name"
  type        = string
  default     = ""
}

variable "github_repository_name" {
  description = "GitHub repository name for ADF source control"
  type        = string
  default     = ""
}

# Network Configuration
variable "public_network_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "enable_private_endpoints" {
  description = "Enable private endpoints for storage"
  type        = bool
  default     = true
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for Azure IR"
  type        = bool
  default     = true
}

# Integration Runtime Configuration
variable "enable_self_hosted_ir" {
  description = "Enable self-hosted integration runtime"
  type        = bool
  default     = false
}

variable "ir_compute_type" {
  description = "Compute type for Azure integration runtime"
  type        = string
  default     = "General"
  validation {
    condition     = contains(["General", "MemoryOptimized", "ComputeOptimized"], var.ir_compute_type)
    error_message = "Invalid compute type. Must be General, MemoryOptimized, or ComputeOptimized."
  }
}

variable "ir_core_count" {
  description = "Core count for Azure integration runtime"
  type        = number
  default     = 8
  validation {
    condition     = contains([8, 16, 32, 64, 128, 256], var.ir_core_count)
    error_message = "Core count must be 8, 16, 32, 64, 128, or 256."
  }
}

variable "ir_ttl_minutes" {
  description = "Time to live in minutes for Azure integration runtime"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

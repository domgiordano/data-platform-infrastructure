# modules/monitoring/variables.tf

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

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "Log retention must be between 30 and 730 days."
  }
}

variable "synapse_workspace_id" {
  description = "ID of the Synapse workspace for diagnostics"
  type        = string
  default     = ""
}

variable "data_factory_id" {
  description = "ID of the Data Factory for diagnostics"
  type        = string
  default     = ""
}

variable "storage_account_id" {
  description = "ID of the storage account for diagnostics"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "ID of the Key Vault for diagnostics"
  type        = string
  default     = ""
}

variable "enable_alerts" {
  description = "Enable metric alerts"
  type        = bool
  default     = true
}

variable "alert_email_address" {
  description = "Email address for alert notifications"
  type        = string
  default     = "admin@example.com"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

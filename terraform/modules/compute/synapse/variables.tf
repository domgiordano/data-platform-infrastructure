# modules/compute/synapse/variables.tf

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

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "data_lake_filesystem_id" {
  description = "ID of the Data Lake Gen2 filesystem for Synapse"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL administrator username"
  type        = string
  default     = "sqladminuser"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL administrator password"
  type        = string
  sensitive   = true
}

variable "managed_identity_id" {
  description = "ID of the user-assigned managed identity"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Synapse"
  type        = string
}

variable "spark_pools" {
  description = "Map of Spark pool configurations"
  type = map(object({
    node_size        = string
    node_count_min   = number
    node_count_max   = number
    auto_pause_delay = number
    spark_version    = string
  }))
  default = {
    small = {
      node_size        = "Small"
      node_count_min   = 3
      node_count_max   = 10
      auto_pause_delay = 15
      spark_version    = "3.3"
    }
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

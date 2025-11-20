# variables.tf - Variable definitions for Azure Data Platform

variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be dev, stg, or prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "data-platform"
}

# GitHub Configuration (for ADF Git integration)
variable "github_account_name" {
  description = "GitHub account/organization name"
  type        = string
  default     = ""
}

variable "github_repository_name" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}

# Synapse Configuration
variable "synapse_sql_admin_username" {
  description = "SQL admin username for Synapse"
  type        = string
  default     = "sqladminuser"
  sensitive   = true
}

variable "synapse_sql_admin_password" {
  description = "SQL admin password for Synapse"
  type        = string
  sensitive   = true
}

variable "synapse_spark_pools" {
  description = "Spark pool configurations"
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

# AI Search Configuration
variable "ai_search_sku" {
  description = "SKU for Azure AI Search"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3"], var.ai_search_sku)
    error_message = "Invalid AI Search SKU."
  }
}

variable "ai_search_replica_count" {
  description = "Number of replicas for AI Search"
  type        = number
  default     = 1
}

variable "ai_search_partition_count" {
  description = "Number of partitions for AI Search"
  type        = number
  default     = 1
}

# OpenAI Configuration
variable "openai_deployments" {
  description = "OpenAI model deployments"
  type = map(object({
    model_name    = string
    model_version = string
    capacity      = number
  }))
  default = {
    gpt4 = {
      model_name    = "gpt-4"
      model_version = "0613"
      capacity      = 10
    }
    embeddings = {
      model_name    = "text-embedding-3-large"
      model_version = "1"
      capacity      = 10
    }
  }
}

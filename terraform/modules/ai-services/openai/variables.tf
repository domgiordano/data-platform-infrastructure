# modules/ai-services/openai/variables.tf

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

variable "subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "sku_name" {
  description = "SKU for OpenAI service"
  type        = string
  default     = "S0"
  validation {
    condition     = contains(["S0"], var.sku_name)
    error_message = "SKU must be S0 for OpenAI."
  }
}

variable "deployments" {
  description = "Map of OpenAI model deployments"
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
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      capacity      = 10
    }
  }
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostics"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# modules/networking/variables.tf

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

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "synapse_subnet_prefix" {
  description = "Address prefix for Synapse subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "datafactory_subnet_prefix" {
  description = "Address prefix for Data Factory subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "storage_subnet_prefix" {
  description = "Address prefix for Storage subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "keyvault_subnet_prefix" {
  description = "Address prefix for Key Vault subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "search_subnet_prefix" {
  description = "Address prefix for AI Search subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "openai_subnet_prefix" {
  description = "Address prefix for OpenAI subnet"
  type        = string
  default     = "10.0.6.0/24"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

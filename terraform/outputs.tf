# outputs.tf - Output values for Azure Data Platform

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.main.location
}

# Storage outputs
output "storage_account_name" {
  description = "Name of the Data Lake storage account"
  value       = module.storage.storage_account_name
}

output "storage_account_id" {
  description = "ID of the Data Lake storage account"
  value       = module.storage.storage_account_id
}

output "storage_primary_endpoint" {
  description = "Primary endpoint for storage account"
  value       = module.storage.primary_dfs_endpoint
}

# Synapse outputs
output "synapse_workspace_name" {
  description = "Name of the Synapse workspace"
  value       = module.synapse.synapse_workspace_name
}

output "synapse_workspace_id" {
  description = "ID of the Synapse workspace"
  value       = module.synapse.synapse_workspace_id
}

output "synapse_endpoint" {
  description = "Synapse workspace endpoint"
  value       = module.synapse.synapse_endpoint
}

output "synapse_spark_pool_names" {
  description = "Names of Synapse Spark pools"
  value       = module.synapse.spark_pool_names
}

# Data Factory outputs
output "data_factory_name" {
  description = "Name of the Data Factory"
  value       = module.data_factory.data_factory_name
}

output "data_factory_id" {
  description = "ID of the Data Factory"
  value       = module.data_factory.data_factory_id
}

# AI Search outputs
output "search_service_name" {
  description = "Name of the AI Search service"
  value       = module.ai_search.search_service_name
}

output "search_service_id" {
  description = "ID of the AI Search service"
  value       = module.ai_search.search_service_id
}

output "search_endpoint" {
  description = "AI Search service endpoint"
  value       = module.ai_search.search_endpoint
}

# OpenAI outputs
output "openai_account_name" {
  description = "Name of the OpenAI account"
  value       = module.openai.openai_account_name
}

output "openai_endpoint" {
  description = "OpenAI service endpoint"
  value       = module.openai.openai_endpoint
}

output "openai_deployment_names" {
  description = "Names of OpenAI model deployments"
  value       = module.openai.deployment_names
}

# Key Vault outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

# Networking outputs
output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = module.networking.vnet_name
}

# Monitoring outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.monitoring.log_analytics_workspace_id
}

output "application_insights_key" {
  description = "Application Insights instrumentation key"
  value       = module.monitoring.application_insights_key
  sensitive   = true
}

# Identity outputs
output "synapse_managed_identity_id" {
  description = "Managed Identity ID for Synapse"
  value       = module.identity.synapse_identity_id
}

output "data_factory_managed_identity_id" {
  description = "Managed Identity ID for Data Factory"
  value       = module.identity.data_factory_identity_id
}

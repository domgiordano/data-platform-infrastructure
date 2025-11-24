# modules/ai-services/openai/outputs.tf

output "openai_account_id" {
  description = "ID of the OpenAI account"
  value       = azurerm_cognitive_account.openai.id
}

output "openai_account_name" {
  description = "Name of the OpenAI account"
  value       = azurerm_cognitive_account.openai.name
}

output "openai_endpoint" {
  description = "Endpoint URL for OpenAI"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_primary_key" {
  description = "Primary access key for OpenAI"
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

output "openai_secondary_key" {
  description = "Secondary access key for OpenAI"
  value       = azurerm_cognitive_account.openai.secondary_access_key
  sensitive   = true
}

output "openai_identity_principal_id" {
  description = "Principal ID of the OpenAI managed identity"
  value       = azurerm_cognitive_account.openai.identity[0].principal_id
}

output "deployment_names" {
  description = "Map of deployment names to their IDs"
  value       = { for k, v in azurerm_cognitive_deployment.deployments : k => v.id }
}

output "deployment_endpoints" {
  description = "Map of deployment names to their model names"
  value = {
    for k, v in azurerm_cognitive_deployment.deployments : k => {
      model_name    = v.model[0].name
      model_version = v.model[0].version
    }
  }
}

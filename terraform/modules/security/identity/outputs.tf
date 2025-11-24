# modules/security/identity/outputs.tf

output "synapse_identity_id" {
  description = "ID of the Synapse managed identity"
  value       = azurerm_user_assigned_identity.synapse.id
}

output "synapse_identity_principal_id" {
  description = "Principal ID of the Synapse managed identity"
  value       = azurerm_user_assigned_identity.synapse.principal_id
}

output "synapse_identity_client_id" {
  description = "Client ID of the Synapse managed identity"
  value       = azurerm_user_assigned_identity.synapse.client_id
}

output "data_factory_identity_id" {
  description = "ID of the Data Factory managed identity"
  value       = azurerm_user_assigned_identity.data_factory.id
}

output "data_factory_identity_principal_id" {
  description = "Principal ID of the Data Factory managed identity"
  value       = azurerm_user_assigned_identity.data_factory.principal_id
}

output "data_factory_identity_client_id" {
  description = "Client ID of the Data Factory managed identity"
  value       = azurerm_user_assigned_identity.data_factory.client_id
}

output "ai_services_identity_id" {
  description = "ID of the AI Services managed identity"
  value       = azurerm_user_assigned_identity.ai_services.id
}

output "ai_services_identity_principal_id" {
  description = "Principal ID of the AI Services managed identity"
  value       = azurerm_user_assigned_identity.ai_services.principal_id
}

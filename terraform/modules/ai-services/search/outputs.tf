# modules/ai-services/search/outputs.tf

output "search_service_id" {
  description = "ID of the AI Search service"
  value       = azurerm_search_service.main.id
}

output "search_service_name" {
  description = "Name of the AI Search service"
  value       = azurerm_search_service.main.name
}

output "search_endpoint" {
  description = "Endpoint URL for AI Search service"
  value       = "https://${azurerm_search_service.main.name}.search.windows.net"
}

output "search_primary_key" {
  description = "Primary admin key for AI Search"
  value       = azurerm_search_service.main.primary_key
  sensitive   = true
}

output "search_secondary_key" {
  description = "Secondary admin key for AI Search"
  value       = azurerm_search_service.main.secondary_key
  sensitive   = true
}

output "search_identity_principal_id" {
  description = "Principal ID of the Search service managed identity"
  value       = azurerm_search_service.main.identity[0].principal_id
}

output "search_query_keys" {
  description = "Query keys for AI Search"
  value       = azurerm_search_service.main.query_keys
  sensitive   = true
}

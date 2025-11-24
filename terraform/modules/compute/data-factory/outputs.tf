# modules/compute/data-factory/outputs.tf

output "data_factory_id" {
  description = "ID of the Data Factory"
  value       = azurerm_data_factory.main.id
}

output "data_factory_name" {
  description = "Name of the Data Factory"
  value       = azurerm_data_factory.main.name
}

output "data_factory_identity_principal_id" {
  description = "Principal ID of the Data Factory system-assigned identity"
  value       = azurerm_data_factory.main.identity[0].principal_id
}

output "data_factory_identity_tenant_id" {
  description = "Tenant ID of the Data Factory identity"
  value       = azurerm_data_factory.main.identity[0].tenant_id
}

output "integration_runtime_azure_id" {
  description = "ID of the Azure integration runtime"
  value       = azurerm_data_factory_integration_runtime_azure.azure.id
}

output "integration_runtime_azure_name" {
  description = "Name of the Azure integration runtime"
  value       = azurerm_data_factory_integration_runtime_azure.azure.name
}

output "linked_service_datalake_id" {
  description = "ID of the Data Lake linked service"
  value       = azurerm_data_factory_linked_service_data_lake_storage_gen2.datalake.id
}

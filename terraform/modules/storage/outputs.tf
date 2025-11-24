# modules/storage/outputs.tf

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.datalake.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.datalake.name
}

output "primary_dfs_endpoint" {
  description = "Primary DFS endpoint"
  value       = azurerm_storage_account.datalake.primary_dfs_endpoint
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.datalake.primary_blob_endpoint
}

output "synapse_filesystem_id" {
  description = "ID of the Synapse filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.synapse.id
}

output "raw_filesystem_name" {
  description = "Name of the raw filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.raw.name
}

output "bronze_filesystem_name" {
  description = "Name of the bronze filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.bronze.name
}

output "silver_filesystem_name" {
  description = "Name of the silver filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.silver.name
}

output "gold_filesystem_name" {
  description = "Name of the gold filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.gold.name
}

output "ai_filesystem_name" {
  description = "Name of the AI filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.ai.name
}

output "search_filesystem_name" {
  description = "Name of the search filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.search.name
}

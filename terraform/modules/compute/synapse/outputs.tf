# modules/compute/synapse/outputs.tf

output "synapse_workspace_id" {
  description = "ID of the Synapse workspace"
  value       = azurerm_synapse_workspace.main.id
}

output "synapse_workspace_name" {
  description = "Name of the Synapse workspace"
  value       = azurerm_synapse_workspace.main.name
}

output "synapse_endpoint" {
  description = "Connectivity endpoint for Synapse workspace"
  value       = azurerm_synapse_workspace.main.connectivity_endpoints["dev"]
}

output "synapse_sql_endpoint" {
  description = "SQL endpoint for Synapse workspace"
  value       = azurerm_synapse_workspace.main.connectivity_endpoints["sql"]
}

output "synapse_sql_on_demand_endpoint" {
  description = "SQL on-demand endpoint for Synapse workspace"
  value       = azurerm_synapse_workspace.main.connectivity_endpoints["sqlOnDemand"]
}

output "synapse_identity_principal_id" {
  description = "Principal ID of the Synapse workspace system-assigned identity"
  value       = azurerm_synapse_workspace.main.identity[0].principal_id
}

output "spark_pool_ids" {
  description = "Map of Spark pool names to IDs"
  value       = { for k, v in azurerm_synapse_spark_pool.pools : k => v.id }
}

output "spark_pool_names" {
  description = "List of Spark pool names"
  value       = [for pool in azurerm_synapse_spark_pool.pools : pool.name]
}

# modules/networking/outputs.tf

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "synapse_subnet_id" {
  description = "ID of the Synapse subnet"
  value       = azurerm_subnet.synapse.id
}

output "datafactory_subnet_id" {
  description = "ID of the Data Factory subnet"
  value       = azurerm_subnet.datafactory.id
}

output "storage_subnet_id" {
  description = "ID of the Storage subnet"
  value       = azurerm_subnet.storage.id
}

output "keyvault_subnet_id" {
  description = "ID of the Key Vault subnet"
  value       = azurerm_subnet.keyvault.id
}

output "search_subnet_id" {
  description = "ID of the AI Search subnet"
  value       = azurerm_subnet.search.id
}

output "openai_subnet_id" {
  description = "ID of the OpenAI subnet"
  value       = azurerm_subnet.openai.id
}

output "private_dns_zone_blob_id" {
  description = "ID of the Blob private DNS zone"
  value       = azurerm_private_dns_zone.blob.id
}

output "private_dns_zone_dfs_id" {
  description = "ID of the DFS private DNS zone"
  value       = azurerm_private_dns_zone.dfs.id
}

output "private_dns_zone_keyvault_id" {
  description = "ID of the Key Vault private DNS zone"
  value       = azurerm_private_dns_zone.keyvault.id
}

output "private_dns_zone_synapse_id" {
  description = "ID of the Synapse private DNS zone"
  value       = azurerm_private_dns_zone.synapse.id
}

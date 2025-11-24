# modules/security/key-vault/outputs.tf

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "synapse_password_secret_id" {
  description = "ID of the Synapse password secret"
  value       = azurerm_key_vault_secret.synapse_password.id
}

output "synapse_password_secret_version" {
  description = "Version of the Synapse password secret"
  value       = azurerm_key_vault_secret.synapse_password.version
}

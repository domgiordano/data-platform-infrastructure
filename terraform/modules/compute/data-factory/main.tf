# modules/compute/data-factory/main.tf - Azure Data Factory

resource "azurerm_data_factory" "main" {
  name                = "adf-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Managed identity configuration
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      var.managed_identity_id
    ]
  }

  # GitHub integration (optional)
  dynamic "github_configuration" {
    for_each = var.github_account_name != "" && var.github_repository_name != "" ? [1] : []
    
    content {
      account_name    = var.github_account_name
      branch_name     = var.environment == "prod" ? "main" : var.environment == "stg" ? "staging" : "develop"
      git_url         = "https://github.com"
      repository_name = var.github_repository_name
      root_folder     = "/adf"
    }
  }

  # Security settings
  public_network_enabled = var.public_network_enabled

  tags = var.tags
}

# Managed Virtual Network for Data Factory (for enhanced security)
resource "azurerm_data_factory_managed_private_endpoint" "storage_blob" {
  count = var.enable_private_endpoints ? 1 : 0

  name               = "pe-adf-storage-blob"
  data_factory_id    = azurerm_data_factory.main.id
  target_resource_id = var.storage_account_id
  subresource_name   = "blob"
}

resource "azurerm_data_factory_managed_private_endpoint" "storage_dfs" {
  count = var.enable_private_endpoints ? 1 : 0

  name               = "pe-adf-storage-dfs"
  data_factory_id    = azurerm_data_factory.main.id
  target_resource_id = var.storage_account_id
  subresource_name   = "dfs"
}

# Integration Runtime - Self-hosted (optional, for on-prem connectivity)
resource "azurerm_data_factory_integration_runtime_self_hosted" "onprem" {
  count = var.enable_self_hosted_ir ? 1 : 0

  name            = "ir-onprem-${var.environment}"
  data_factory_id = azurerm_data_factory.main.id

  description = "Self-hosted integration runtime for on-premises connectivity"
}

# Integration Runtime - Azure (default)
resource "azurerm_data_factory_integration_runtime_azure" "azure" {
  name            = "ir-azure-${var.environment}"
  data_factory_id = azurerm_data_factory.main.id
  location        = var.location

  compute_type        = var.ir_compute_type
  core_count          = var.ir_core_count
  time_to_live_min    = var.ir_ttl_minutes
  cleanup_enabled     = true
  virtual_network_enabled = var.enable_vnet_integration

  description = "Azure integration runtime for cloud data movement"
}

# Linked Service - Azure Data Lake Storage
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "datalake" {
  name            = "ls_datalake_${var.environment}"
  data_factory_id = azurerm_data_factory.main.id

  url = "https://${var.storage_account_name}.dfs.core.windows.net"

  # Use managed identity for authentication
  use_managed_identity = true
}

# Linked Service - Key Vault (for secret management)
resource "azurerm_data_factory_linked_service_key_vault" "keyvault" {
  count = var.key_vault_id != "" ? 1 : 0

  name            = "ls_keyvault_${var.environment}"
  data_factory_id = azurerm_data_factory.main.id
  key_vault_id    = var.key_vault_id
}

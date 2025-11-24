# modules/compute/synapse/main.tf - Azure Synapse Analytics

# Generate random password if not provided
resource "random_password" "synapse_sql_admin" {
  length  = 16
  special = true
}

resource "azurerm_synapse_workspace" "main" {
  name                                 = "synapse-${var.project_name}-${var.environment}"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.data_lake_filesystem_id
  sql_administrator_login              = var.sql_admin_username
  sql_administrator_login_password     = var.sql_admin_password

  # Managed identity configuration
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      var.managed_identity_id
    ]
  }

  # Security and networking
  public_network_access_enabled = false
  managed_virtual_network_enabled = true

  tags = var.tags
}

# Azure AD admin (optional - using service principal for now)
resource "azurerm_synapse_workspace_aad_admin" "main" {
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  login                = "AzureAD Admin"
  object_id            = data.azurerm_client_config.current.object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
}

data "azurerm_client_config" "current" {}

# Synapse Firewall Rules
resource "azurerm_synapse_firewall_rule" "allow_azure_services" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

# Synapse Managed Private Endpoint for Storage
resource "azurerm_synapse_managed_private_endpoint" "storage_dfs" {
  name                 = "pe-synapse-storage-dfs"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  target_resource_id   = var.storage_account_id
  subresource_name     = "dfs"

  depends_on = [azurerm_synapse_workspace.main]
}

resource "azurerm_synapse_managed_private_endpoint" "storage_blob" {
  name                 = "pe-synapse-storage-blob"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  target_resource_id   = var.storage_account_id
  subresource_name     = "blob"

  depends_on = [azurerm_synapse_workspace.main]
}

# Spark Pools
resource "azurerm_synapse_spark_pool" "pools" {
  for_each = var.spark_pools

  name                 = "spark${each.key}${var.environment}"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  node_size_family     = "MemoryOptimized"
  node_size            = each.value.node_size
  node_count           = each.value.node_count_min

  auto_scale {
    min_node_count = each.value.node_count_min
    max_node_count = each.value.node_count_max
  }

  auto_pause {
    delay_in_minutes = each.value.auto_pause_delay
  }

  spark_version = each.value.spark_version

  # Library requirements (can be customized per environment)
  library_requirement {
    content  = <<-EOT
      pandas==2.0.3
      numpy==1.24.3
      scikit-learn==1.3.0
      azure-storage-blob==12.17.0
      azure-identity==1.13.0
    EOT
    filename = "requirements.txt"
  }

  tags = var.tags
}

# SQL Pool (optional - typically not used in modern architectures)
# Uncomment if you need a dedicated SQL pool
# resource "azurerm_synapse_sql_pool" "main" {
#   name                 = "sql${var.environment}"
#   synapse_workspace_id = azurerm_synapse_workspace.main.id
#   sku_name             = "DW100c"
#   create_mode          = "Default"
#   
#   tags = var.tags
# }

# Role Assignment - Synapse to Storage
resource "azurerm_role_assignment" "synapse_storage_blob" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.main.identity[0].principal_id
}

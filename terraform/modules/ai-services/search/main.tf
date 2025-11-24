# modules/ai-services/search/main.tf - Azure AI Search

resource "azurerm_search_service" "main" {
  name                = "search-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  # Replica and partition configuration
  replica_count   = var.replica_count
  partition_count = var.partition_count

  # Security settings
  public_network_access_enabled = false
  local_authentication_enabled  = true

  # Managed identity
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Private Endpoint for Search
resource "azurerm_private_endpoint" "search" {
  name                = "pe-${azurerm_search_service.main.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-search"
    private_connection_resource_id = azurerm_search_service.main.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
  }

  tags = var.tags
}

# Diagnostic Settings for AI Search
resource "azurerm_monitor_diagnostic_setting" "search" {
  count = var.log_analytics_workspace_id != "" ? 1 : 0

  name                       = "diag-${azurerm_search_service.main.name}"
  target_resource_id         = azurerm_search_service.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "OperationLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Optional: Shared Private Link to Storage (for indexer data sources)
resource "azurerm_search_shared_private_link_service" "storage" {
  count = var.storage_account_id != "" ? 1 : 0

  name               = "spl-storage"
  search_service_id  = azurerm_search_service.main.id
  subresource_name   = "blob"
  target_resource_id = var.storage_account_id
  request_message    = "Please approve this private link for AI Search to access storage"
}

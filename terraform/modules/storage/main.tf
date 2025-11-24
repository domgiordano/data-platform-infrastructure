# modules/storage/main.tf - Azure Data Lake Storage Gen2

resource "azurerm_storage_account" "datalake" {
  name                     = "st${var.project_name}${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  is_hns_enabled           = true  # Hierarchical namespace for Data Lake Gen2
  
  # Security settings
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  
  # Network rules
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [var.subnet_id]
  }

  blob_properties {
    versioning_enabled       = true
    change_feed_enabled      = true
    last_access_time_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Data Lake Containers/File Systems
resource "azurerm_storage_data_lake_gen2_filesystem" "raw" {
  name               = "raw"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "Landing zone for raw data ingestion"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "bronze"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "Bronze layer - raw data with minimal transformations"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
  name               = "silver"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "Silver layer - cleaned and conformed data"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name               = "gold"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "Gold layer - business-level aggregates and curated data"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "ai" {
  name               = "ai"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "AI/ML models and artifacts"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "search" {
  name               = "search"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "Search indexes and documents"
  }
}

# Synapse workspace filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "synapse" {
  name               = "synapse"
  storage_account_id = azurerm_storage_account.datalake.id

  properties = {
    description = "Synapse workspace filesystem"
  }
}

# Create folder structure in raw container
resource "azurerm_storage_data_lake_gen2_path" "raw_incoming" {
  path               = "incoming"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.raw.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "raw_archive" {
  path               = "archive"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.raw.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Create folder structure in bronze container
resource "azurerm_storage_data_lake_gen2_path" "bronze_tables" {
  path               = "tables"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.bronze.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Create folder structure in silver container
resource "azurerm_storage_data_lake_gen2_path" "silver_tables" {
  path               = "tables"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.silver.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Create folder structure in gold container
resource "azurerm_storage_data_lake_gen2_path" "gold_aggregates" {
  path               = "aggregates"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.gold.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "gold_reports" {
  path               = "reports"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.gold.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Create folder structure in AI container
resource "azurerm_storage_data_lake_gen2_path" "ai_models" {
  path               = "models"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.ai.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "ai_embeddings" {
  path               = "embeddings"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.ai.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Create folder structure in search container
resource "azurerm_storage_data_lake_gen2_path" "search_indexes" {
  path               = "indexes"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.search.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "search_documents" {
  path               = "documents"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.search.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Private Endpoint for Blob
resource "azurerm_private_endpoint" "blob" {
  name                = "pe-${azurerm_storage_account.datalake.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-blob"
    private_connection_resource_id = azurerm_storage_account.datalake.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags
}

# Private Endpoint for DFS (Data Lake)
resource "azurerm_private_endpoint" "dfs" {
  name                = "pe-${azurerm_storage_account.datalake.name}-dfs"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-dfs"
    private_connection_resource_id = azurerm_storage_account.datalake.id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }

  tags = var.tags
}

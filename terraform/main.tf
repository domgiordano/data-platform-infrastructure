# main.tf - Main Terraform configuration for Azure Data Platform

# Current Azure AD client configuration
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = merge(
    local.common_tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  environment      = var.environment
  location         = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name     = var.project_name
  
  tags = local.common_tags
}

# Storage Module (Data Lake Gen2)
module "storage" {
  source = "./modules/storage"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  subnet_id           = module.networking.storage_subnet_id
  
  tags = local.common_tags
}

# Key Vault Module
module "key_vault" {
  source = "./modules/security/key-vault"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subnet_id           = module.networking.keyvault_subnet_id
  
  synapse_sql_admin_password = var.synapse_sql_admin_password
  
  tags = local.common_tags
}

# Managed Identity Module
module "identity" {
  source = "./modules/security/identity"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  tags = local.common_tags
}

# Synapse Analytics Module
module "synapse" {
  source = "./modules/compute/synapse"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  storage_account_id          = module.storage.storage_account_id
  storage_account_name        = module.storage.storage_account_name
  data_lake_filesystem_id     = module.storage.synapse_filesystem_id
  
  sql_admin_username          = var.synapse_sql_admin_username
  sql_admin_password          = var.synapse_sql_admin_password
  
  managed_identity_id         = module.identity.synapse_identity_id
  subnet_id                   = module.networking.synapse_subnet_id
  
  spark_pools                 = var.synapse_spark_pools
  
  tags = local.common_tags
  
  depends_on = [module.storage, module.identity]
}

# Data Factory Module
module "data_factory" {
  source = "./modules/compute/data-factory"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  managed_identity_id         = module.identity.data_factory_identity_id
  subnet_id                   = module.networking.datafactory_subnet_id
  
  github_account_name         = var.github_account_name
  github_repository_name      = var.github_repository_name
  
  tags = local.common_tags
  
  depends_on = [module.identity]
}

# AI Search Module
module "ai_search" {
  source = "./modules/ai-services/search"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  sku                 = var.ai_search_sku
  replica_count       = var.ai_search_replica_count
  partition_count     = var.ai_search_partition_count
  
  subnet_id           = module.networking.search_subnet_id
  
  tags = local.common_tags
}

# OpenAI Module
module "openai" {
  source = "./modules/ai-services/openai"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  deployments         = var.openai_deployments
  subnet_id           = module.networking.openai_subnet_id
  
  tags = local.common_tags
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  
  synapse_workspace_id    = module.synapse.synapse_workspace_id
  data_factory_id         = module.data_factory.data_factory_id
  storage_account_id      = module.storage.storage_account_id
  key_vault_id            = module.key_vault.key_vault_id
  
  tags = local.common_tags
  
  depends_on = [
    module.synapse,
    module.data_factory,
    module.storage,
    module.key_vault
  ]
}

# RBAC Assignments
resource "azurerm_role_assignment" "synapse_storage" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.identity.synapse_identity_principal_id
}

resource "azurerm_role_assignment" "adf_storage" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.identity.data_factory_identity_principal_id
}

# Local variables
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# modules/security/identity/main.tf - Managed Identities

# Managed Identity for Synapse
resource "azurerm_user_assigned_identity" "synapse" {
  name                = "id-synapse-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Managed Identity for Data Factory
resource "azurerm_user_assigned_identity" "data_factory" {
  name                = "id-datafactory-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Managed Identity for AI Services (optional, for future use)
resource "azurerm_user_assigned_identity" "ai_services" {
  name                = "id-aiservices-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

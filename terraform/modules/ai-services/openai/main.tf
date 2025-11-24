# modules/ai-services/openai/main.tf - Azure OpenAI Service

resource "azurerm_cognitive_account" "openai" {
  name                = "openai-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = var.sku_name

  # Security settings
  public_network_access_enabled = false
  custom_subdomain_name         = "openai-${var.project_name}-${var.environment}"

  # Managed identity
  identity {
    type = "SystemAssigned"
  }

  # Network ACLs
  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id                            = var.subnet_id
      ignore_missing_vnet_service_endpoint = false
    }
  }

  tags = var.tags
}

# OpenAI Model Deployments
resource "azurerm_cognitive_deployment" "deployments" {
  for_each = var.deployments

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = "Standard"
    capacity = each.value.capacity
  }
}

# Private Endpoint for OpenAI
resource "azurerm_private_endpoint" "openai" {
  name                = "pe-${azurerm_cognitive_account.openai.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-openai"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  tags = var.tags
}

# Diagnostic Settings for OpenAI
resource "azurerm_monitor_diagnostic_setting" "openai" {
  count = var.log_analytics_workspace_id != "" ? 1 : 0

  name                       = "diag-${azurerm_cognitive_account.openai.name}"
  target_resource_id         = azurerm_cognitive_account.openai.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "RequestResponse"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}

# modules/monitoring/main.tf - Monitoring and Observability

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = var.tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "appi-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"

  tags = var.tags
}

# Diagnostic Settings - Synapse Workspace
resource "azurerm_monitor_diagnostic_setting" "synapse" {
  count = var.synapse_workspace_id != "" ? 1 : 0

  name                       = "diag-synapse-${var.environment}"
  target_resource_id         = var.synapse_workspace_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "SynapseRbacOperations"
  }

  enabled_log {
    category = "GatewayApiRequests"
  }

  enabled_log {
    category = "BuiltinSqlReqsEnded"
  }

  enabled_log {
    category = "IntegrationPipelineRuns"
  }

  enabled_log {
    category = "IntegrationActivityRuns"
  }

  enabled_log {
    category = "IntegrationTriggerRuns"
  }

  enabled_metric {
    category = "AllMetrics"
  }

}

# Diagnostic Settings - Data Factory
resource "azurerm_monitor_diagnostic_setting" "data_factory" {
  count = var.data_factory_id != "" ? 1 : 0

  name                       = "diag-adf-${var.environment}"
  target_resource_id         = var.data_factory_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "PipelineRuns"
  }

  enabled_log {
    category = "TriggerRuns"
  }

  enabled_log {
    category = "ActivityRuns"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings - Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage" {
  count = var.storage_account_id != "" ? 1 : 0

  name                       = "diag-storage-${var.environment}"
  target_resource_id         = var.storage_account_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_metric {
    category = "Transaction"
  }

  enabled_metric {
    category = "Capacity"
  }

}

# Diagnostic Settings - Key Vault
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  count = var.key_vault_id != "" ? 1 : 0

  name                       = "diag-keyvault-${var.environment}"
  target_resource_id         = var.key_vault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = substr("${var.project_name}${var.environment}", 0, 12)

  email_receiver {
    name          = "admin-email"
    email_address = var.alert_email_address
  }

  tags = var.tags
}

# Alert - Data Factory Pipeline Failures
resource "azurerm_monitor_metric_alert" "adf_pipeline_failures" {
  count = var.data_factory_id != "" && var.enable_alerts ? 1 : 0

  name                = "alert-adf-pipeline-failures-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.data_factory_id]
  description         = "Alert when Data Factory pipeline fails"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "PipelineFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Alert - Storage Account Availability
resource "azurerm_monitor_metric_alert" "storage_availability" {
  count = var.storage_account_id != "" && var.enable_alerts ? 1 : 0

  name                = "alert-storage-availability-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.storage_account_id]
  description         = "Alert when storage availability drops below threshold"
  severity            = 1
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99.9
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Alert - Synapse SQL Pool DTU Usage
resource "azurerm_monitor_metric_alert" "synapse_dtu" {
  count = var.synapse_workspace_id != "" && var.enable_alerts ? 1 : 0

  name                = "alert-synapse-dtu-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.synapse_workspace_id]
  description         = "Alert when Synapse DWU usage is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Synapse/workspaces"
    metric_name      = "DWUUsedPercent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Workbook for Data Platform Monitoring
resource "azurerm_application_insights_workbook" "data_platform" {
  name                = "workbook-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "Data Platform Monitoring - ${upper(var.environment)}"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## Data Platform Health Dashboard\n### Environment: ${upper(var.environment)}"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "AzureDiagnostics | where ResourceProvider == \"MICROSOFT.DATAFACTORY\" | summarize count() by bin(TimeGenerated, 1h)"
          size = 0
          title = "Data Factory Activity (Last 24h)"
          timeContext = {
            durationMs = 86400000
          }
          queryType = 0
          resourceType = "microsoft.operationalinsights/workspaces"
        }
      }
    ]
  })

  tags = var.tags
}

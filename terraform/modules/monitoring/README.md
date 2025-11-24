# Monitoring Module

Creates Log Analytics workspace, Application Insights, diagnostic settings, and alerts.

## Resources Created

- Log Analytics Workspace
- Application Insights
- Diagnostic settings (Synapse, ADF, Storage, Key Vault)
- Action Group for alerts
- Metric alerts (pipeline failures, storage availability, Synapse DTU)
- Monitoring workbook

## Inputs

| Name                 | Description                     | Type        | Default           | Required |
| -------------------- | ------------------------------- | ----------- | ----------------- | -------- |
| environment          | Environment (dev/stg/prod)      | string      | -                 | yes      |
| location             | Azure region                    | string      | -                 | yes      |
| resource_group_name  | Resource group name             | string      | -                 | yes      |
| project_name         | Project name                    | string      | -                 | yes      |
| log_retention_days   | Log retention (30-730 days)     | number      | 30                | no       |
| synapse_workspace_id | Synapse ID for diagnostics      | string      | ""                | no       |
| data_factory_id      | Data Factory ID for diagnostics | string      | ""                | no       |
| storage_account_id   | Storage ID for diagnostics      | string      | ""                | no       |
| key_vault_id         | Key Vault ID for diagnostics    | string      | ""                | no       |
| enable_alerts        | Enable metric alerts            | bool        | true              | no       |
| alert_email_address  | Email for alerts                | string      | admin@example.com | no       |
| tags                 | Resource tags                   | map(string) | {}                | no       |

## Outputs

| Name                                   | Description                      |
| -------------------------------------- | -------------------------------- |
| log_analytics_workspace_id             | Log Analytics workspace ID       |
| log_analytics_workspace_name           | Log Analytics workspace name     |
| log_analytics_workspace_key            | Workspace shared key (sensitive) |
| application_insights_id                | Application Insights ID          |
| application_insights_name              | Application Insights name        |
| application_insights_key               | Instrumentation key (sensitive)  |
| application_insights_connection_string | Connection string (sensitive)    |
| application_insights_app_id            | App ID                           |
| action_group_id                        | Action group ID                  |
| workbook_id                            | Monitoring workbook ID           |

## Alerts Configured

1. **ADF Pipeline Failures**: Triggers when any pipeline fails
2. **Storage Availability**: Triggers when availability < 99.9%
3. **Synapse DTU Usage**: Triggers when DWU usage > 80%

## Diagnostic Logs Enabled

**Synapse**:

- SynapseRbacOperations, GatewayApiRequests, BuiltinSqlReqsEnded
- IntegrationPipelineRuns, IntegrationActivityRuns, IntegrationTriggerRuns

**Data Factory**:

- PipelineRuns, TriggerRuns, ActivityRuns

**Storage**:

- Transaction, Capacity metrics

**Key Vault**:

- AuditEvent, AzurePolicyEvaluationDetails

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  environment          = "dev"
  location             = "eastus"
  resource_group_name  = "rg-dataplatform-dev"
  project_name         = "dataplatform"
  log_retention_days   = 30
  synapse_workspace_id = module.synapse.synapse_workspace_id
  data_factory_id      = module.data_factory.data_factory_id
  storage_account_id   = module.storage.storage_account_id
  key_vault_id         = module.key_vault.key_vault_id
  enable_alerts        = true
  alert_email_address  = "alerts@company.com"
  tags                 = local.common_tags
}
```

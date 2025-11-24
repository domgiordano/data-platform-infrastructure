# Synapse Module

Creates Azure Synapse Analytics workspace with Spark pools and managed private endpoints.

## Resources Created

- Synapse workspace
- Azure AD admin configuration
- Firewall rules (allow Azure services)
- Managed private endpoints (storage blob + dfs)
- Spark pools (configurable sizes)
- RBAC: Storage Blob Data Contributor

## Inputs

| Name                    | Description                | Type        | Default      | Required |
| ----------------------- | -------------------------- | ----------- | ------------ | -------- |
| environment             | Environment (dev/stg/prod) | string      | -            | yes      |
| location                | Azure region               | string      | -            | yes      |
| resource_group_name     | Resource group name        | string      | -            | yes      |
| project_name            | Project name               | string      | -            | yes      |
| storage_account_id      | Storage account ID         | string      | -            | yes      |
| storage_account_name    | Storage account name       | string      | -            | yes      |
| data_lake_filesystem_id | Synapse filesystem ID      | string      | -            | yes      |
| sql_admin_username      | SQL admin username         | string      | sqladminuser | no       |
| sql_admin_password      | SQL admin password         | string      | -            | yes      |
| managed_identity_id     | User-assigned identity ID  | string      | -            | yes      |
| subnet_id               | Subnet ID                  | string      | -            | yes      |
| spark_pools             | Spark pool configs         | map(object) | small pool   | no       |
| tags                    | Resource tags              | map(string) | {}           | no       |

## Outputs

| Name                           | Description                  |
| ------------------------------ | ---------------------------- |
| synapse_workspace_id           | Synapse workspace ID         |
| synapse_workspace_name         | Synapse workspace name       |
| synapse_endpoint               | Dev endpoint                 |
| synapse_sql_endpoint           | SQL endpoint                 |
| synapse_sql_on_demand_endpoint | SQL on-demand endpoint       |
| synapse_identity_principal_id  | System identity principal ID |
| spark_pool_ids                 | Map of pool names to IDs     |
| spark_pool_names               | List of Spark pool names     |

## Features

- Managed VNet enabled
- Public network access disabled
- Python libraries pre-installed (pandas, numpy, scikit-learn, azure SDKs)
- Auto-pause and auto-scale configured

## Usage

```hcl
module "synapse" {
  source = "./modules/compute/synapse"

  environment             = "dev"
  location                = "eastus"
  resource_group_name     = "rg-dataplatform-dev"
  project_name            = "dataplatform"
  storage_account_id      = module.storage.storage_account_id
  storage_account_name    = module.storage.storage_account_name
  data_lake_filesystem_id = module.storage.synapse_filesystem_id
  sql_admin_username      = "sqladminuser"
  sql_admin_password      = var.synapse_sql_admin_password
  managed_identity_id     = module.identity.synapse_identity_id
  subnet_id               = module.networking.synapse_subnet_id

  spark_pools = {
    small = {
      node_size        = "Small"
      node_count_min   = 3
      node_count_max   = 10
      auto_pause_delay = 15
      spark_version    = "3.3"
    }
  }

  tags = local.common_tags
}
```

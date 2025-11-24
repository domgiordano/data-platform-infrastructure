# AI Search Module

Creates Azure AI Search service with private endpoint and diagnostic logging.

## Resources Created

- AI Search service
- Private Endpoint
- Diagnostic settings (optional)
- Shared private link to storage (optional)

## Inputs

| Name                       | Description                         | Type        | Default  | Required |
| -------------------------- | ----------------------------------- | ----------- | -------- | -------- |
| environment                | Environment (dev/stg/prod)          | string      | -        | yes      |
| location                   | Azure region                        | string      | -        | yes      |
| resource_group_name        | Resource group name                 | string      | -        | yes      |
| project_name               | Project name                        | string      | -        | yes      |
| subnet_id                  | Subnet ID for private endpoint      | string      | -        | yes      |
| sku                        | Search SKU                          | string      | standard | no       |
| replica_count              | Number of replicas (1-12)           | number      | 1        | no       |
| partition_count            | Number of partitions (1,2,3,4,6,12) | number      | 1        | no       |
| storage_account_id         | Storage ID for shared private link  | string      | ""       | no       |
| log_analytics_workspace_id | Log Analytics ID for diagnostics    | string      | ""       | no       |
| tags                       | Resource tags                       | map(string) | {}       | no       |

## Outputs

| Name                         | Description                     |
| ---------------------------- | ------------------------------- |
| search_service_id            | Search service ID               |
| search_service_name          | Search service name             |
| search_endpoint              | Search endpoint URL             |
| search_primary_key           | Primary admin key (sensitive)   |
| search_secondary_key         | Secondary admin key (sensitive) |
| search_identity_principal_id | System identity principal ID    |
| search_query_keys            | Query keys (sensitive)          |

## SKU Options

- `free` - Dev/test only
- `basic` - Small workloads
- `standard` - Production (default)
- `standard2` - Large workloads
- `standard3` - Very large workloads

## Features

- Public network access disabled
- System-assigned managed identity
- Diagnostic logging enabled
- Query keys for read-only access

## Usage

```hcl
module "ai_search" {
  source = "./modules/ai-services/search"

  environment                = "dev"
  location                   = "eastus"
  resource_group_name        = "rg-dataplatform-dev"
  project_name               = "dataplatform"
  subnet_id                  = module.networking.search_subnet_id
  sku                        = "standard"
  replica_count              = 1
  partition_count            = 1
  storage_account_id         = module.storage.storage_account_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  tags                       = local.common_tags
}
```

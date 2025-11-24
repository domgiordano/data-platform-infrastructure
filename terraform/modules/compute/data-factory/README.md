# Data Factory Module

Creates Azure Data Factory with GitHub integration, integration runtimes, and linked services.

## Resources Created

- Data Factory
- GitHub configuration (optional)
- Managed private endpoints (storage)
- Azure Integration Runtime
- Self-hosted IR (optional)
- Linked Services (Data Lake, Key Vault)

## Inputs

| Name                     | Description                      | Type        | Default | Required |
| ------------------------ | -------------------------------- | ----------- | ------- | -------- |
| environment              | Environment (dev/stg/prod)       | string      | -       | yes      |
| location                 | Azure region                     | string      | -       | yes      |
| resource_group_name      | Resource group name              | string      | -       | yes      |
| project_name             | Project name                     | string      | -       | yes      |
| managed_identity_id      | User-assigned identity ID        | string      | -       | yes      |
| subnet_id                | Subnet ID                        | string      | -       | yes      |
| storage_account_id       | Storage ID for private endpoints | string      | ""      | no       |
| storage_account_name     | Storage name for linked service  | string      | ""      | no       |
| key_vault_id             | Key Vault ID for linked service  | string      | ""      | no       |
| github_account_name      | GitHub account/org               | string      | ""      | no       |
| github_repository_name   | GitHub repo name                 | string      | ""      | no       |
| public_network_enabled   | Enable public access             | bool        | false   | no       |
| enable_private_endpoints | Enable storage private endpoints | bool        | true    | no       |
| enable_vnet_integration  | Enable VNet for Azure IR         | bool        | true    | no       |
| enable_self_hosted_ir    | Enable self-hosted IR            | bool        | false   | no       |
| ir_compute_type          | IR compute type                  | string      | General | no       |
| ir_core_count            | IR core count                    | number      | 8       | no       |
| ir_ttl_minutes           | IR TTL minutes                   | number      | 10      | no       |
| tags                     | Resource tags                    | map(string) | {}      | no       |

## Outputs

| Name                               | Description                  |
| ---------------------------------- | ---------------------------- |
| data_factory_id                    | Data Factory ID              |
| data_factory_name                  | Data Factory name            |
| data_factory_identity_principal_id | System identity principal ID |
| data_factory_identity_tenant_id    | Identity tenant ID           |
| integration_runtime_azure_id       | Azure IR ID                  |
| integration_runtime_azure_name     | Azure IR name                |
| linked_service_datalake_id         | Data Lake linked service ID  |

## Features

- GitHub integration with branch per environment
- Managed identity authentication
- VNet-integrated integration runtime
- Auto-cleanup enabled

## Usage

```hcl
module "data_factory" {
  source = "./modules/compute/data-factory"

  environment              = "dev"
  location                 = "eastus"
  resource_group_name      = "rg-dataplatform-dev"
  project_name             = "dataplatform"
  managed_identity_id      = module.identity.data_factory_identity_id
  subnet_id                = module.networking.datafactory_subnet_id
  storage_account_id       = module.storage.storage_account_id
  storage_account_name     = module.storage.storage_account_name
  key_vault_id             = module.key_vault.key_vault_id
  github_account_name      = "your-org"
  github_repository_name   = "adf-repo"
  tags                     = local.common_tags
}
```

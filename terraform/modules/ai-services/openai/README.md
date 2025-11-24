# OpenAI Module

Creates Azure OpenAI service with model deployments and private endpoint.

## Resources Created

- Cognitive Account (OpenAI)
- Model deployments (GPT-4, embeddings, etc.)
- Private Endpoint
- Diagnostic settings (optional)

## Inputs

| Name                       | Description                      | Type        | Default           | Required |
| -------------------------- | -------------------------------- | ----------- | ----------------- | -------- |
| environment                | Environment (dev/stg/prod)       | string      | -                 | yes      |
| location                   | Azure region                     | string      | -                 | yes      |
| resource_group_name        | Resource group name              | string      | -                 | yes      |
| project_name               | Project name                     | string      | -                 | yes      |
| subnet_id                  | Subnet ID for private endpoint   | string      | -                 | yes      |
| sku_name                   | OpenAI SKU                       | string      | S0                | no       |
| deployments                | Map of model deployments         | map(object) | gpt4 + embeddings | no       |
| log_analytics_workspace_id | Log Analytics ID for diagnostics | string      | ""                | no       |
| tags                       | Resource tags                    | map(string) | {}                | no       |

## Deployment Object Structure

```hcl
{
  model_name    = string  # e.g., "gpt-4", "text-embedding-ada-002"
  model_version = string  # e.g., "0613", "2"
  capacity      = number  # TPM thousands (10 = 10K TPM)
}
```

## Outputs

| Name                         | Description                      |
| ---------------------------- | -------------------------------- |
| openai_account_id            | OpenAI account ID                |
| openai_account_name          | OpenAI account name              |
| openai_endpoint              | OpenAI endpoint URL              |
| openai_primary_key           | Primary access key (sensitive)   |
| openai_secondary_key         | Secondary access key (sensitive) |
| openai_identity_principal_id | System identity principal ID     |
| deployment_names             | Map of deployment names to IDs   |
| deployment_endpoints         | Map of deployment details        |

## Common Models

- **GPT-4**: `gpt-4` (versions: 0613, 1106-Preview)
- **GPT-3.5**: `gpt-35-turbo` (version: 0613)
- **Embeddings**: `text-embedding-ada-002` (version: 2), `text-embedding-3-large` (version: 1)

## Features

- Public network access disabled
- Custom subdomain for endpoint
- Network ACLs with VNet integration
- Audit and request/response logging

## Usage

```hcl
module "openai" {
  source = "./modules/ai-services/openai"

  environment         = "dev"
  location            = "eastus"
  resource_group_name = "rg-dataplatform-dev"
  project_name        = "dataplatform"
  subnet_id           = module.networking.openai_subnet_id

  deployments = {
    gpt4 = {
      model_name    = "gpt-4"
      model_version = "0613"
      capacity      = 10
    }
    embeddings = {
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      capacity      = 10
    }
  }

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  tags                       = local.common_tags
}
```

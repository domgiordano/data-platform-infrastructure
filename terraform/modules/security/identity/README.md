# Identity Module

Creates user-assigned managed identities for Azure services.

## Resources Created

- Synapse managed identity
- Data Factory managed identity
- AI Services managed identity

## Inputs

| Name                | Description                | Type        | Default | Required |
| ------------------- | -------------------------- | ----------- | ------- | -------- |
| environment         | Environment (dev/stg/prod) | string      | -       | yes      |
| location            | Azure region               | string      | -       | yes      |
| resource_group_name | Resource group name        | string      | -       | yes      |
| project_name        | Project name               | string      | -       | yes      |
| tags                | Resource tags              | map(string) | {}      | no       |

## Outputs

| Name                               | Description                                   |
| ---------------------------------- | --------------------------------------------- |
| synapse_identity_id                | Synapse identity resource ID                  |
| synapse_identity_principal_id      | Synapse identity principal ID (for RBAC)      |
| synapse_identity_client_id         | Synapse identity client ID                    |
| data_factory_identity_id           | Data Factory identity resource ID             |
| data_factory_identity_principal_id | Data Factory identity principal ID (for RBAC) |
| data_factory_identity_client_id    | Data Factory identity client ID               |
| ai_services_identity_id            | AI Services identity resource ID              |
| ai_services_identity_principal_id  | AI Services identity principal ID             |

## Usage

```hcl
module "identity" {
  source = "./modules/security/identity"

  environment         = "dev"
  location            = "eastus"
  resource_group_name = "rg-dataplatform-dev"
  project_name        = "dataplatform"
  tags                = local.common_tags
}
```

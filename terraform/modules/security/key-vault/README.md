# Key Vault Module

Creates Azure Key Vault with secrets, access policies, and private endpoint.

## Resources Created

- Key Vault (with random suffix for uniqueness)
- Access policy for Terraform service principal
- Synapse SQL admin password secret
- Private Endpoint

## Inputs

| Name                       | Description                    | Type        | Default | Required |
| -------------------------- | ------------------------------ | ----------- | ------- | -------- |
| environment                | Environment (dev/stg/prod)     | string      | -       | yes      |
| location                   | Azure region                   | string      | -       | yes      |
| resource_group_name        | Resource group name            | string      | -       | yes      |
| project_name               | Project name                   | string      | -       | yes      |
| tenant_id                  | Azure AD tenant ID             | string      | -       | yes      |
| subnet_id                  | Subnet ID for private endpoint | string      | -       | yes      |
| synapse_sql_admin_password | Synapse password to store      | string      | -       | yes      |
| tags                       | Resource tags                  | map(string) | {}      | no       |

## Outputs

| Name                            | Description                     |
| ------------------------------- | ------------------------------- |
| key_vault_id                    | Key Vault resource ID           |
| key_vault_name                  | Key Vault name                  |
| key_vault_uri                   | Key Vault URI                   |
| synapse_password_secret_id      | Synapse password secret ID      |
| synapse_password_secret_version | Synapse password secret version |

## Features

- Purge protection enabled
- Soft delete (7 days)
- Network ACLs (deny public, allow Azure services + subnet)
- Private endpoint for secure access

## Usage

```hcl
module "key_vault" {
  source = "./modules/security/key-vault"

  environment                = "dev"
  location                   = "eastus"
  resource_group_name        = "rg-dataplatform-dev"
  project_name               = "dataplatform"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  subnet_id                  = module.networking.keyvault_subnet_id
  synapse_sql_admin_password = var.synapse_sql_admin_password
  tags                       = local.common_tags
}
```

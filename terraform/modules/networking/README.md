# Networking Module

Creates VNet, subnets, NSGs, and private DNS zones for secure Azure data platform networking.

## Resources Created

- Virtual Network (10.0.0.0/16)
- 6 Subnets (Synapse, Data Factory, Storage, Key Vault, Search, OpenAI)
- Network Security Groups
- 4 Private DNS Zones (blob, dfs, keyvault, synapse)

## Inputs

| Name                | Description                | Type         | Default         | Required |
| ------------------- | -------------------------- | ------------ | --------------- | -------- |
| environment         | Environment (dev/stg/prod) | string       | -               | yes      |
| location            | Azure region               | string       | -               | yes      |
| resource_group_name | Resource group name        | string       | -               | yes      |
| project_name        | Project name               | string       | -               | yes      |
| vnet_address_space  | VNet CIDR                  | list(string) | ["10.0.0.0/16"] | no       |
| tags                | Resource tags              | map(string)  | {}              | no       |

## Outputs

| Name                  | Description            |
| --------------------- | ---------------------- |
| vnet_id               | Virtual Network ID     |
| vnet_name             | Virtual Network name   |
| synapse_subnet_id     | Synapse subnet ID      |
| datafactory_subnet_id | Data Factory subnet ID |
| storage_subnet_id     | Storage subnet ID      |
| keyvault_subnet_id    | Key Vault subnet ID    |
| search_subnet_id      | AI Search subnet ID    |
| openai_subnet_id      | OpenAI subnet ID       |
| private*dns_zone*\*   | Private DNS zone IDs   |

## Usage

```hcl
module "networking" {
  source = "./modules/networking"

  environment         = "dev"
  location            = "eastus"
  resource_group_name = "rg-dataplatform-dev"
  project_name        = "dataplatform"
  tags                = local.common_tags
}
```

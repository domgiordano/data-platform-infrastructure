# Storage Module

Creates Azure Data Lake Storage Gen2 with medallion architecture (raw/bronze/silver/gold).

## Resources Created

- Storage Account (Data Lake Gen2)
- 7 Filesystems (raw, bronze, silver, gold, ai, search, synapse)
- Folder structure in each filesystem
- Private Endpoints (blob + dfs)

## Inputs

| Name                | Description                        | Type        | Default | Required |
| ------------------- | ---------------------------------- | ----------- | ------- | -------- |
| environment         | Environment (dev/stg/prod)         | string      | -       | yes      |
| location            | Azure region                       | string      | -       | yes      |
| resource_group_name | Resource group name                | string      | -       | yes      |
| project_name        | Project name                       | string      | -       | yes      |
| subnet_id           | Subnet ID for private endpoints    | string      | -       | yes      |
| replication_type    | Storage replication (LRS/GRS/GZRS) | string      | LRS     | no       |
| tags                | Resource tags                      | map(string) | {}      | no       |

## Outputs

| Name                  | Description                                              |
| --------------------- | -------------------------------------------------------- |
| storage_account_id    | Storage account ID                                       |
| storage_account_name  | Storage account name                                     |
| primary_dfs_endpoint  | DFS endpoint URL                                         |
| primary_blob_endpoint | Blob endpoint URL                                        |
| synapse_filesystem_id | Synapse filesystem ID                                    |
| \*\_filesystem_name   | Filesystem names (raw, bronze, silver, gold, ai, search) |

## Usage

```hcl
module "storage" {
  source = "./modules/storage"

  environment         = "dev"
  location            = "eastus"
  resource_group_name = "rg-dataplatform-dev"
  project_name        = "dataplatform"
  subnet_id           = module.networking.storage_subnet_id
  replication_type    = "LRS"
  tags                = local.common_tags
}
```

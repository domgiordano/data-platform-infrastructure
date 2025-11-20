# data-platform-infra

Infrastructure as Code for Azure Data Platform using Terraform Cloud.

## Overview

Manages all Azure infrastructure for the data platform including:
- Azure Synapse Analytics & Spark Pools
- Azure Data Lake Storage Gen2
- Azure Data Factory
- Azure AI Search & OpenAI
- Networking & Security

## Setup

### Prerequisites
- Terraform >= 1.5
- Terraform Cloud account
- Azure Service Principal

### Terraform Cloud Configuration

1. Create workspaces with tag `azure-data-platform`:
   - `azure-data-platform-dev`
   - `azure-data-platform-stg`
   - `azure-data-platform-prod`

2. Set environment variables in each workspace:
   ```
   ARM_CLIENT_ID
   ARM_CLIENT_SECRET
   ARM_SUBSCRIPTION_ID
   ARM_TENANT_ID
   ```

3. Update `terraform.tf` with your organization:
   ```hcl
   cloud {
     organization = "your-org"
   }
   ```

## Usage

### Local Development
```bash
terraform init
terraform workspace select dev
terraform plan -var-file=environments/dev.tfvars
```

### Deployment
Push to branch triggers Terraform Cloud:
- `develop` → dev workspace
- `staging` → stg workspace  
- `main` → prod workspace (manual approval)

## Outputs

Key outputs available for other repos:
- `synapse_workspace_name`
- `data_factory_name`
- `storage_account_name`
- `search_service_name`
- `key_vault_name`

## Repository Integration

Backend and Frontend repos fetch these outputs via Terraform Cloud API to configure deployments.

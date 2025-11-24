# Azure Data Platform Infrastructure

Infrastructure as Code for a complete Azure Data Platform using Terraform Cloud.

## 🏗️ Architecture Overview

This infrastructure creates a secure, enterprise-grade data platform with:

- **Data Lake Storage Gen2** - Multi-tier data architecture (raw, bronze, silver, gold, ai, search)
- **Azure Synapse Analytics** - Data warehousing and big data analytics with Spark pools
- **Azure Data Factory** - Data orchestration and ETL pipelines
- **Azure AI Search** - Intelligent search capabilities
- **Azure OpenAI** - Large language models and embeddings
- **Networking** - VNet with private endpoints for secure communication
- **Security** - Key Vault for secrets, managed identities for authentication
- **Monitoring** - Log Analytics, Application Insights, and alerts

## 📋 Prerequisites

1. **Azure Subscription** with appropriate permissions
2. **Terraform Cloud Account**
3. **Azure Service Principal** with Contributor role
4. **Terraform** >= 1.5 installed locally (for testing)

## 🚀 Quick Start

### 1. Create Azure Service Principal

```bash
# Login to Azure
az login

# Create service principal
az ad sp create-for-rbac --name "terraform-data-platform" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}

# Note the output:
# - appId (ARM_CLIENT_ID)
# - password (ARM_CLIENT_SECRET)
# - tenant (ARM_TENANT_ID)
```

### 2. Configure Terraform Cloud

1. **Create Organization** (if you don't have one)

   - Go to https://app.terraform.io
   - Create a new organization

2. **Create Workspaces** with tag `azure-data-platform`:

   ```
   - azure-data-platform-dev
   - azure-data-platform-stg
   - azure-data-platform-prod
   ```

3. **Set Environment Variables** in each workspace:

   ```
   ARM_CLIENT_ID       = <your-service-principal-app-id>
   ARM_CLIENT_SECRET   = <your-service-principal-password> (mark as sensitive)
   ARM_SUBSCRIPTION_ID = <your-azure-subscription-id>
   ARM_TENANT_ID       = <your-azure-tenant-id>
   ```

4. **Set Terraform Variables** in each workspace:

   ```
   synapse_sql_admin_password = <generate-strong-password> (mark as sensitive)
   ```

5. **Update `terraform.tf`**:
   ```hcl
   cloud {
     organization = "your-org-name"  # <-- Change this

     workspaces {
       tags = ["azure-data-platform"]
     }
   }
   ```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Select workspace
terraform workspace select dev

# Plan deployment
terraform plan -var-file=environments/dev.tfvars

# Apply
terraform apply -var-file=environments/dev.tfvars
```

## 📁 Project Structure

```
.
├── terraform.tf              # Terraform Cloud & provider configuration
├── main.tf                   # Main orchestration
├── variables.tf              # Variable definitions
├── outputs.tf                # Outputs for other repos
├── environments/             # Environment configs
│   ├── dev.tfvars
│   ├── stg.tfvars
│   └── prod.tfvars
└── modules/
    ├── networking/           # VNet, subnets, private DNS
    ├── storage/              # Data Lake Gen2
    ├── security/
    │   ├── identity/         # Managed identities
    │   └── key-vault/        # Key Vault
    ├── compute/
    │   ├── synapse/          # Synapse & Spark
    │   └── data-factory/     # ADF
    ├── ai-services/
    │   ├── search/           # AI Search
    │   └── openai/           # OpenAI
    └── monitoring/           # Logs & Alerts
```

## 🔐 Security Features

- ✅ Private endpoints for all services
- ✅ VNet isolation
- ✅ Managed identities
- ✅ Key Vault for secrets
- ✅ Network ACLs
- ✅ Diagnostic logging

## 📊 Data Lake Structure

```
├── raw/         # Landing zone
├── bronze/      # Raw with minimal transforms
├── silver/      # Cleaned & conformed
├── gold/        # Business aggregates
├── ai/          # AI/ML artifacts
├── search/      # Search indexes
└── synapse/     # Synapse files
```

## 📤 Key Outputs

```
storage_account_name
synapse_workspace_name
data_factory_name
search_service_name
openai_account_name
key_vault_name
```

## 🚨 Monitoring

- Log Analytics (30-day retention)
- Application Insights
- Alerts for failures & performance

## 💰 Cost Optimization

- Auto-pause Spark pools
- Right-sized resources per environment
- Managed identities (no rotation costs)

## 📚 Resources

- [Azure Synapse Docs](https://docs.microsoft.com/azure/synapse-analytics/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Cloud Docs](https://www.terraform.io/cloud-docs)

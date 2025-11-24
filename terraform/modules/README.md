# Terraform Modules Documentation

Quick reference for all infrastructure modules.

## Module Overview

| Module                                          | Purpose                | Key Resources                                     |
| ----------------------------------------------- | ---------------------- | ------------------------------------------------- |
| [networking](./networking/)                     | Network infrastructure | VNet, 6 subnets, NSGs, private DNS                |
| [storage](./storage/)                           | Data Lake Gen2         | Storage account, 7 filesystems, private endpoints |
| [security/identity](./security/identity/)       | Managed identities     | 3 user-assigned identities                        |
| [security/key-vault](./security/key-vault/)     | Secrets management     | Key Vault, secrets, private endpoint              |
| [compute/synapse](./compute/synapse/)           | Data warehouse         | Synapse workspace, Spark pools                    |
| [compute/data-factory](./compute/data-factory/) | Data orchestration     | ADF, integration runtimes, linked services        |
| [ai-services/search](./ai-services/search/)     | Search service         | AI Search, private endpoint                       |
| [ai-services/openai](./ai-services/openai/)     | AI models              | OpenAI, model deployments                         |
| [monitoring](./monitoring/)                     | Observability          | Log Analytics, App Insights, alerts               |

## Module Dependencies

```
networking (no deps)
    ↓
storage ← networking
identity (no deps)
key-vault ← networking + identity
    ↓
synapse ← storage + identity + networking
data-factory ← identity + networking
ai-search ← networking
openai ← networking
    ↓
monitoring ← all compute & storage modules
```

## Common Input Variables

All modules accept:

- `environment` - Environment (dev/stg/prod)
- `location` - Azure region
- `resource_group_name` - Resource group name
- `project_name` - Project name for naming
- `tags` - Map of resource tags

## Naming Conventions

Resources follow the pattern:

- `<type>-<project>-<environment>[-<suffix>]`
- Examples:
  - `vnet-dataplatform-dev`
  - `synapse-dataplatform-prod`
  - `kv-dataplatform-dev-a1b2` (with random suffix)

## Security Features

All modules implement:

- ✅ Private endpoints where applicable
- ✅ Network ACLs (deny public by default)
- ✅ Managed identities for authentication
- ✅ Diagnostic logging to Log Analytics
- ✅ Resource-level RBAC

## Quick Start

1. Deploy networking first
2. Deploy storage + identity + key-vault
3. Deploy compute services (synapse, data-factory)
4. Deploy AI services (search, openai)
5. Deploy monitoring last

See each module's README for detailed configuration options.

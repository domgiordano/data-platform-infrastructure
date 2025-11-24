# modules/networking/main.tf - Networking infrastructure

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.tags
}

# Subnet for Synapse
resource "azurerm_subnet" "synapse" {
  name                 = "snet-synapse-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.synapse_subnet_prefix]
  
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Sql",
    "Microsoft.KeyVault"
  ]
}

# Subnet for Data Factory
resource "azurerm_subnet" "datafactory" {
  name                 = "snet-datafactory-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.datafactory_subnet_prefix]
  
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Sql",
    "Microsoft.KeyVault"
  ]
}

# Subnet for Storage (Private Endpoints)
resource "azurerm_subnet" "storage" {
  name                 = "snet-storage-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.storage_subnet_prefix]
  
  service_endpoints = ["Microsoft.Storage"]
}

# Subnet for Key Vault (Private Endpoints)
resource "azurerm_subnet" "keyvault" {
  name                 = "snet-keyvault-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.keyvault_subnet_prefix]
  
  service_endpoints = ["Microsoft.KeyVault"]
}

# Subnet for AI Search
resource "azurerm_subnet" "search" {
  name                 = "snet-search-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.search_subnet_prefix]
  
  service_endpoints = ["Microsoft.CognitiveServices"]
}

# Subnet for OpenAI
resource "azurerm_subnet" "openai" {
  name                 = "snet-openai-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.openai_subnet_prefix]
  
  service_endpoints = ["Microsoft.CognitiveServices"]
}

# Network Security Group for data services
resource "azurerm_network_security_group" "data_services" {
  name                = "nsg-data-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# NSG Rule - Allow Azure services
resource "azurerm_network_security_rule" "allow_azure_services" {
  name                        = "AllowAzureServices"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureCloud"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data_services.name
}

# Associate NSG with subnets
resource "azurerm_subnet_network_security_group_association" "synapse" {
  subnet_id                 = azurerm_subnet.synapse.id
  network_security_group_id = azurerm_network_security_group.data_services.id
}

resource "azurerm_subnet_network_security_group_association" "datafactory" {
  subnet_id                 = azurerm_subnet.datafactory.id
  network_security_group_id = azurerm_network_security_group.data_services.id
}

# Private DNS Zones
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "dfs" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "synapse" {
  name                = "privatelink.azuresynapse.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link DNS zones to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "blob-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs" {
  name                  = "dfs-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dfs.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "keyvault-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "synapse" {
  name                  = "synapse-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.synapse.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

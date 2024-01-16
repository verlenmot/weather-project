# Virtual Network

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.project_instance}"
  location            = "westeurope"
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.project_name}-${var.project_instance}"
  resource_group_name = var.rg_name
  location            = "westeurope"
}

# Private Subnet

resource "azurerm_subnet" "private" {
  name                 = "snet-${var.project_name}-${var.project_instance}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets[0]]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]


  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Public Subnet

resource "azurerm_subnet" "public" {
  name                 = "snet-public-${var.project_name}-${var.project_instance}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets[1]]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

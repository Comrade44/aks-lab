resource "azurerm_resource_group" "core-network-rg" {
  name     = "rg-uks-net-01"
  location = "uksouth"
}

resource "azurerm_virtual_network" "core-vnet" {
  name                = "vnet-uks-core-01"
  location            = azurerm_resource_group.core-network-rg.location
  resource_group_name = azurerm_resource_group.core-network-rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "core-subnet" {
  name                 = "snet-uks-core-01"
  virtual_network_name = azurerm_virtual_network.core-vnet.name
  resource_group_name  = azurerm_resource_group.core-network-rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db-subnet" {
  name                 = "snet-uks-db-01"
  virtual_network_name = azurerm_virtual_network.core-vnet.name
  resource_group_name  = azurerm_resource_group.core-network-rg.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "core-nsg" {
  name                = "nsg-uks-core-01"
  location            = azurerm_resource_group.core-network-rg.location
  resource_group_name = azurerm_resource_group.core-network-rg.name
}

resource "azurerm_network_security_rule" "default-deny" {
  name                        = "Default-inbound-deny"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.core-network-rg.name
  network_security_group_name = azurerm_network_security_group.core-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "core-subnet-nsg" {
  subnet_id                 = azurerm_subnet.core-subnet.id
  network_security_group_id = azurerm_network_security_group.core-nsg.id
}

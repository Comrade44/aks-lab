resource "azurerm_resource_group" "db-rg" {
  name     = "rg-uks-db-01"
  location = "uksouth"
}

resource "azurerm_public_ip" "pip-db-01" {
  name                = "pip-uks-vm-db-01"
  location            = azurerm_resource_group.db-rg.location
  resource_group_name = azurerm_resource_group.db-rg.name
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "nic-db-01" {
  name                = "nic-uks-db-01"
  location            = azurerm_resource_group.db-rg.location
  resource_group_name = azurerm_resource_group.db-rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.db-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-db-01.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-db" {
  name                  = "vm-uks-db-01"
  location              = azurerm_resource_group.db-rg.location
  resource_group_name   = azurerm_resource_group.db-rg.name
  size                  = "Standard_B2s"
  admin_username        = "demoadmin"
  network_interface_ids = [azurerm_network_interface.nic-db-01.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  admin_ssh_key {
    username   = "demoadmin"
    public_key = var.aks_ssh_public_key
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-focal"
    sku       = "minimal-20_04-lts"
    version   = "20.04.202004230"
  }
}
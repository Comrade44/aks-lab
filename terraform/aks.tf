resource "azurerm_resource_group" "aks-rg" {
  name     = "rg-uks-aks-01"
  location = "uksouth"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  name                = local.cluster_config.name
  dns_prefix          = local.cluster_config.dns_prefix

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name    = local.default_node_pool_config.node_pool_name
    vm_size = local.default_node_pool_config.node_pool_vm_size
  }
  linux_profile {
    admin_username = local.cluster_config.admin_username

    ssh_key {
      key_data = var.aks_ssh_public_key
    }
  }
  network_profile {
    network_plugin    = local.cluster_config.network_plugin
    load_balancer_sku = local.cluster_config.load_balancer_sku
  }
}
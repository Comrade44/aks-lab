resource "azurerm_resource_group" "aks-rg" {
  name     = "rg-uks-aks-01"
  location = "uksouth"
}

resource "random_string" "deployment-code" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_kubernetes_cluster" "k8s" {
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  name                = local.cluster_config.name
  dns_prefix          = local.cluster_config.dns_prefix

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
  }

  api_server_access_profile {
    authorized_ip_ranges = ["188.210.212.168"]
  }
  default_node_pool {
    name       = local.default_node_pool_config.node_pool_name
    vm_size    = local.default_node_pool_config.node_pool_vm_size
    node_count = local.default_node_pool_config.node_count
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
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
    network_policy    = "azure"
  }
}

resource "azurerm_container_registry" "cr-aks-lab" {
  name                = "crakslab${random_string.deployment-code.result}"
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.cr-aks-lab.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}

resource "azurerm_storage_account" "aks-storage" {
  name                     = "stgakslab${random_string.deployment-code.result}"
  location                 = azurerm_resource_group.aks-rg.location
  resource_group_name      = azurerm_resource_group.aks-rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
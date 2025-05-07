variable "aks_ssh_public_key" {
  type        = string
  description = "Public key for ssh authentication to the AKS cluster"
  sensitive   = true
}

variable "aks_cluster_config" {
  type = object({
    name                      = string
    dns_prefix                = string
    admin_username            = string
    default_node_pool_name    = string
    default_node_pool_vm_size = string
    network_plugin            = string
    load_balancer_sku         = string
  })
}
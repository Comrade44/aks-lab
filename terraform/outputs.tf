output "kube_config" {
  value       = yamlencode(azurerm_kubernetes_cluster.k8s.kube_config_raw)
  description = "kube_config file"
  sensitive   = true
}
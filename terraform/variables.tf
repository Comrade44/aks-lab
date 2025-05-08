variable "aks_ssh_public_key" {
  type        = string
  description = "Public key for ssh authentication to the AKS cluster"
  sensitive   = true
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  insecure  = true
  api_token = var.proxmox_api_token
}
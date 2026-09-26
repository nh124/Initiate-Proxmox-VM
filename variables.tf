variable "proxmox_endpoint" {
  description = "Endpoint for the Proxmox API"
  type        = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "vm_username" {
  type      = string
  sensitive = true
}

variable "vm_password" {
  type      = string
  sensitive = true
}



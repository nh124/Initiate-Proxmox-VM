variable "ubuntu_image_url" {
  description = "URL of the Ubuntu cloud image to download"
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "ubuntu_image_file_name" {
  description = "File name of the downloaded Ubuntu cloud image"
  type        = string
  default     = "ubuntu-24.04-server-cloudimg-amd64.qcow2"
}

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



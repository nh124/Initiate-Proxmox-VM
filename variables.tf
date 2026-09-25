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

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "forgejo-dev-server"
}

variable "memory" {
  description = "Memory allocated to the VM in MB"
  type        = number
  default     = 2048
}

variable "cpu_cores" {
  description = "Number of CPU cores allocated to the VM"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Size of the disk allocated to the VM in GB"
  type        = number
  default     = 10
}

variable "node_name" {
  description = "Name of the Proxmox node to deploy the VM on"
  type        = string
  default     = "pve"
}

variable "bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}

variable "datastore_id" {
  description = "Proxmox datastore for the VM disk"
  type        = string
  default     = "big-4tb"
}

variable "image_datastore_id" {
  description = "Proxmox datastore used to store the downloaded image"
  type        = string
  default     = "local"
}

variable "vm_username" {
  description = "Username for the VM"
  type        = string
}

variable "vm_password" {
  description = "Password for the VM"
  type        = string
  sensitive   = true
}


variable "proxmox_endpoint" {
  description = "Endpoint for the Proxmox API"
  type        = string
  default   = "https://192.168.0.200:8006/"
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}




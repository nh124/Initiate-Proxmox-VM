variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "unnamed-vm"
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

variable "disk_interface" {
  description = "Disk interface type for the VM disk"
  type        = string
  default     = "virtio0"
}

variable "enable_qemu_agent" {
  description = "Whether to enable the QEMU agent for the VM"
  type        = bool
  default     = false
}

variable "vm_ip_address" {
  description = "IP address for the VM (use 'dhcp' for automatic assignment)"
  type        = string
  default     = "dhcp"
}

variable "disk_iothread" {
  description = "Whether to enable I/O thread for the VM disk"
  type        = bool
  default     = true
}

variable "disk_discard" {
  description = "Whether to enable discard (TRIM) for the VM disk"
  type        = string
  default     = "on"
}

variable "node_name" {
  description = "Name of the Proxmox node to deploy the VM on"
  type        = string
  default     = "pve"
}

variable "stop_on_destroy" {
  description = "Whether to stop the VM when destroying it"
  type        = bool
  default     = true
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



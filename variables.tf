variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "pve"
}

variable "datastore_id" {
  type    = string
  default = "big-4tb"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "talos_version" {
  type    = string
  default = "v1.14.0"
}

variable "cluster_name" {
  type    = string
  default = "serverden"
}

variable "control_plane_ip" {
  type    = string
  default = "192.168.0.50"
}

variable "cluster_endpoint" {
  type    = string
  default = "https://192.168.0.50:6443"
}
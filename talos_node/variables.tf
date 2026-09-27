variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "machine_secrets" {
  type      = any
  sensitive = true
}

variable "talos_version" {
  type = string
}

variable "ip" {
  type = string
}

variable "network_interface" {
  type = string
}

variable "network_gateway" {
  type = string
}

variable "network_mtu" {
  type = number
}
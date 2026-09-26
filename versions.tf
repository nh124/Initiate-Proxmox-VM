terraform {
  required_version = ">= 1.11.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.114.0"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.12.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}
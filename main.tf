resource "proxmox_download_file" "ubuntu" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.node_name

  url        = var.ubuntu_image_url
  file_name  = var.ubuntu_image_file_name
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "terraform_test" {
  name      = var.vm_name
  node_name = var.node_name

  stop_on_destroy = true

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    import_from  = proxmox_download_file.ubuntu.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_username
      password = var.vm_password
    }
  }

  network_device {
    bridge = var.bridge
  }

  agent {
    enabled = false
  }
}

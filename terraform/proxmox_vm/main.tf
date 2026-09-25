resource "proxmox_virtual_environment_vm" "terraform_test" {
  name      = var.vm_name
  node_name = var.node_name

  stop_on_destroy = var.stop_on_destroy

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    import_from  = proxmox_download_file.ubuntu.id
    interface    = var.disk_interface
    iothread     = var.disk_iothread
    discard      = var.disk_discard
    size         = var.disk_size
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.vm_ip_address
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
    enabled = var.enable_qemu_agent
  }
}
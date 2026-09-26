resource "proxmox_virtual_environment_vm" "talos" {
  vm_id           = var.vm_id
  name            = var.name
  node_name       = var.node_name
  started         = true
  stop_on_destroy = true
  machine = "q35"
  bios    = "ovmf"
  cpu {
    type    = "host"
    cores   = var.cores
    sockets = 1
  }
  memory {
    dedicated = var.memory
  }
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.disk_size
    discard      = "on"
  }
  cdrom {
    file_id = proxmox_download_file.talos_iso.id
  }
  network_device {
    bridge      = var.bridge
    model       = "virtio"
    mac_address = var.mac_address
  }
  boot_order = [
    "ide3",
    "scsi0"
  ]
  serial_device {
    device = "socket"
  }
  vga {
    type = "std"
  }
}
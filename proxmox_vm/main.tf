resource "proxmox_virtual_environment_vm" "talos" {
  vm_id           = var.vm_id
  name            = var.name
  node_name       = var.node_name
  started         = true
  stop_on_destroy = true
  machine         = "q35"
  bios            = "ovmf"
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
    iothread     = true
    discard      = "on"
  }
  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_iso.id
  }
  network_device {
    bridge      = var.bridge
    mac_address = var.mac_address
    model       = "virtio"
  }
  boot_order = ["ide2", "scsi0"]
  serial_device {
    device = "socket"
  }
  vga {
    type = "serial0"
  }
}
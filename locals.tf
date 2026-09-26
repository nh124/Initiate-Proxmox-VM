locals {
  vms = {
    200 = {
      name        = "talos-cp-01"
      role        = "controlplane"
      cores       = 4
      memory      = 8192
      disk_size   = 64
      ip_address  = "192.168.0.50"
      mac_address = "BC:24:11:00:00:50"
    }
  }
}
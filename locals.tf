locals {
  vms = {
    200 = {
      name        = "talos-cp-01"
      role        = "controlplane"
      cores       = 4
      memory      = 8192
      disk_size   = 64
      mac_address = "BC:24:11:00:00:50"
    }
    201 = {
      name        = "talos-worker-01"
      role        = "worker"
      cores       = 4
      memory      = 8192
      disk_size   = 64
      mac_address = "BC:24:11:00:00:51"
    }
  }
}
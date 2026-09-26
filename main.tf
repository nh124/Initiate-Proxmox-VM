module "proxmox_vm" {
  source = "./proxmox_vm"

  for_each = local.vms

  vm_id       = each.key
  name        = each.value.name
  cores       = each.value.cores
  memory      = each.value.memory
  disk_size   = each.value.disk_size
  ip_address  = each.value.ip_address
  mac_address = each.value.mac_address

  node_name    = var.proxmox_node
  datastore_id = var.datastore_id
  bridge       = var.network_bridge
}
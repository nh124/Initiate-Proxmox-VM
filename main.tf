module "proxmox_vm" {
  source = "./proxmox_vm"
  for_each = {
    for vm in local.vms : vm.name => vm
  }
  vm_name   = each.value.name
  cpu_cores    = each.value.cpu
  memory    = each.value.ram
  disk_size   = each.value.disk
  bridge = each.value.bridge
  vm_username = var.vm_username
  vm_password = var.vm_password
}

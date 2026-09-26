resource "proxmox_download_file" "ubuntu" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.node_name

  url        = var.ubuntu_image_url
  file_name  = var.ubuntu_image_file_name
  overwrite_unmanaged = true
}

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
}

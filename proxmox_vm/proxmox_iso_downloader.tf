resource "proxmox_download_file" "talos_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node_name
  url          = "https://github.com/siderolabs/talos/releases/download/v1.14.0/metal-amd64.iso"
  file_name    = "talos-v1.14.0-metal-amd64.iso"
}
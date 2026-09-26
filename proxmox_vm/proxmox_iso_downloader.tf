resource "proxmox_download_file" "ubuntu" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.node_name

  url        = var.ubuntu_image_url
  file_name  = var.ubuntu_image_file_name
  overwrite_unmanaged = true
}
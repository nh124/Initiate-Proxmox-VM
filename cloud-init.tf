resource "proxmox_virtual_environment_file" "nextcloud_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"

  source_raw {
    data = file("${path.module}/cloud-init/nextcloud.yaml")
    file_name = "nextcloud.yaml"
  }
}
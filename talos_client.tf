data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration

  endpoints = [
    var.control_plane_ip
  ]

  nodes = [
    var.control_plane_ip
  ]
}

resource "local_sensitive_file" "talosconfig" {
  content  = data.talos_client_configuration.this.talos_config
  filename = "${path.root}/talos/talosconfig"

  depends_on = [
    talos_machine_bootstrap.controlplane
  ]
}
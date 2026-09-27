resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version

  config_patches = [
    yamlencode({
      machine = {
        network = {
          interfaces = [
            {
              interface = "eth0"

              dhcp = false

              addresses = [
                "192.168.0.117/24"
              ]

              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = "192.168.0.1"
                }
              ]

              mtu = 1500
            }
          ]

          nameservers = [
            "192.168.0.1"
          ]
        }
      }
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [var.control_plane_ip]
  nodes                = [var.control_plane_ip]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration

  node = var.control_plane_ip

  depends_on = [
    module.proxmox_vm
  ]
}

resource "talos_machine_bootstrap" "controlplane" {
  node                 = var.control_plane_ip
  client_configuration = talos_machine_secrets.this.client_configuration

  depends_on = [
    talos_machine_configuration_apply.controlplane
  ]
}

resource "local_sensitive_file" "talosconfig" {
  content  = data.talos_client_configuration.this.talos_config
  filename = "${path.root}/talos/talosconfig"

  depends_on = [
    talos_machine_bootstrap.controlplane
  ]
}
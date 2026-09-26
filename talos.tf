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
        install = {
          disk = "/dev/sda"
        }

        network = {
          hostname = "talos-cp-01"
        }
      }

      cluster = {
        allowSchedulingOnControlPlanes = true
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration = talos_machine_secrets.this.client_configuration

  machine_configuration_input =
    data.talos_machine_configuration.controlplane.machine_configuration

  node = var.control_plane_ip

  depends_on = [
    module.proxmox_vm
  ]
}
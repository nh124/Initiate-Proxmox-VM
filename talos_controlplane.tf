module "talos_controlplane" {
  source = "./talos_node"

  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version

  ip                = var.control_plane_ip
  network_interface = var.network_interface
  network_gateway   = var.network_gateway
  network_mtu       = var.network_mtu
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = module.talos_controlplane.machine_configuration

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
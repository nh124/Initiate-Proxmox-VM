module "talos_worker" {
  source = "./talos_node"

  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version

  ip                = "192.168.0.118"
  network_interface = var.network_interface
  network_gateway   = var.network_gateway
  network_mtu       = var.network_mtu
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = module.talos_worker.machine_configuration

  node = "192.168.0.118"

  depends_on = [
    module.proxmox_vm
  ]
}
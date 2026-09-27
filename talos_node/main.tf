data "talos_machine_configuration" "this" {
  cluster_name     = var.cluster_name
  machine_type     = var.machine_type
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = var.machine_secrets
  talos_version    = var.talos_version

  config_patches = [
    yamlencode({
      machine = {
        network = {
          interfaces = [
            {
              interface = var.network_interface

              dhcp = false

              addresses = [
                "${var.ip}/24"
              ]

              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = var.network_gateway
                }
              ]

              mtu = var.network_mtu
            }
          ]
        }
      }
    })
  ]
}

output "machine_configuration" {
  value     = data.talos_machine_configuration.this.machine_configuration
  sensitive = true
}
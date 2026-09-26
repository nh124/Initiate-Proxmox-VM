locals {
  vms = [
    # {
    #   name   = "nextcloud"
    #   cpu    = 4
    #   ram    = 4096
    #   disk   = 2000
    #   bridge = "vmbr0"
    # },
    # {
    #   name   = "vaultwarden"
    #   cpu    = 4
    #   ram    = 6144
    #   disk   = 100
    #   bridge = "vmbr0"
    # },
    # {
    #   name   = "immich"
    #   cpu    = 4
    #   ram    = 6144
    #   disk   = 2020
    #   bridge = "vmbr0"
    # },
    # {
    #   name   = "n8n"
    #   cpu    = 2
    #   ram    = 2048
    #   disk   = 10
    #   bridge = "vmbr0"
    # },
    # {
    #   name   = "jellyfin"
    #   cpu    = 2
    #   ram    = 2048
    #   disk   = 2016
    #   bridge = "vmbr0"
    # },
    # {
    #   name   = "mattermost"
    #   cpu    = 2
    #   ram    = 4048
    #   disk   = 8
    #   bridge = "vmbr0"
    # }
  ]
  automation_containers = [
    {
      name   = "jfrog-container-registry"
      cpu    = 4
      ram    = 8096
      disk   = 20
      bridge = "vmbr0"
    },
  ]
}
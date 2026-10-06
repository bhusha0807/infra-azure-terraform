variable "subnet_id" {}
variable "rg_name" {}
variable "location" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "dev-aks-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "dev-k8s"

  default_node_pool {
    name           = "nodegroup1"
    node_count     = 1
    vm_size        = "Standard_D2s_v4" # Budget-friendly tier for testing
    vnet_subnet_id = var.subnet_id
  }

# THIS PREVENTS AZURE FROM DRIFTING ON THE OIDC CONFIGURATION
  oidc_issuer_enabled = true

  # THIS SEPARATES INTERNAL KUBERNETES IPS FROM YOUR PHYSICAL VNET IPS
  network_profile {
    network_plugin     = "kubenet"
    service_cidr       = "172.16.0.0/16" # Non-overlapping range
    dns_service_ip     = "172.16.0.10"
  }

  identity {
    type = "SystemAssigned"
  }
}

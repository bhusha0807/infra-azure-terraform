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
    vm_size        = "Standard_B2s" # Budget-friendly tier for testing
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}

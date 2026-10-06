resource "azurerm_resource_group" "rg" {
  name     = "devops-live-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "dev-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-nodes-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

output "subnet_id" { value = azurerm_subnet.aks_subnet.id }
output "rg_name"   { value = azurerm_resource_group.rg.name }
output "location"  { value = azurerm_resource_group.rg.location }

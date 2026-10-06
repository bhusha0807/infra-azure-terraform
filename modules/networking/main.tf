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

resource "azurerm_container_registry" "acr" {
  name                = "bhushandevopsregistry" # Must be unique globally, lowercase letters and numbers only
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"                 # Most cost-effective tier for testing
  admin_enabled       = true
}

# 1. Create a Network Security Group to act as a cloud firewall
resource "azurerm_network_security_group" "nsg" {
  name                = "dev-aks-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow public HTTP web traffic on port 80 to pass through cleanly
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 2. Attach this firewall group directly onto your cluster's subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source = "../../modules/networking"
}

module "k8s_cluster" {
  source    = "../../modules/aks"
  location  = module.network.location
  rg_name   = module.network.rg_name
  subnet_id = module.network.subnet_id
}

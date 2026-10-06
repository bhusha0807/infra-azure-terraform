terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
  # THIS IS THE REMOTE BACKEND LOCKING IN YOUR STATE FILE
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "bhushantfstate2026" # Make sure this matches the name from Step 1
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
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

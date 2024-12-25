terraform {
  backend "azurerm" {
    resource_group_name  = "NetflixProject"
    virtual_network_name = "netflix-network"
    storage_account_name = "tfstatest"
    container_name       = "tfstate"
    key                  = "netflix.tfstate"
  }
} 
terraform {
  backend "azurerm" {
    resource_group_name  = "NetflixProject"
    storage_account_name = "tfstatest"
    container_name       = "tfstate"
    key                  = "netflix.tfstate"
  }
} 
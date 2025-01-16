terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Empty block - values come from backend-config
  }
}

provider "azurerm" {
  features {}
} 
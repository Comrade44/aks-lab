terraform {
  required_version = ">= 1.11.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.27.0"
    }
  }
  backend "azurerm" {
    key = "aks-lab.tfstate"
  }
}

provider "azurerm" {
  features {}
}
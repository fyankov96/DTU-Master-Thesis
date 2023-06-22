terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.54.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "6162102d-ca97-4f6f-823b-3901a6f74733"
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.94.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  #required_version = ">= 0.12, < 0.13"
  backend "azurerm" {
    resource_group_name  = "nt-poc-akshaya"
    storage_account_name = "sinkstrgadf" 
    container_name       = "sink" 
    key                  = "oneClick/container/terraform.tfstate"
  }
}

resource "azurerm_storage_container" "nai_container" {
  name                  = "${var.firstname}${var.lastname}container"
  storage_account_name  = var.storageAcc
  container_access_type = var.container_access_type
}

output "container_rmid"{
  value = azurerm_storage_container.nai_container.resource_manager_id
}

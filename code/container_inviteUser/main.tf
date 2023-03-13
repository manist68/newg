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
    storage_account_name = "naiglobalstrg"
    resource_group_name  = "nai-global-dev-rg"
    container_name       = "ocs-tfstate"
    key                  = "oneClick/dev/ocs-centralindia/container/terraform.tfstate"
  }
}

locals {
    email_prefix = split("@",var.user_email_address)[0]
}

locals {
 name1 = replace(local.email_prefix,".","")
}

locals{
  name2 = replace(local.name1,"-","")
}

resource "azurerm_storage_container" "nai_container" {
  name                  = "${local.name2}container"
  storage_account_name  = var.storageAcc
  container_access_type = var.container_access_type
}

output "container_rmid"{
  value = azurerm_storage_container.nai_container.resource_manager_id
}
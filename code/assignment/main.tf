provider "azurerm" {
  skip_provider_registration = "true"
  #version = "=2.15"
  features {}
}

provider "azuread" {}

terraform {
  #required_version = ">= 0.12, < 0.13"
  backend "azurerm" {
    storage_account_name = "naiglobalstrg"
    resource_group_name  = "nai-global-dev-rg"
    container_name       = "ocs-tfstate"
    key                  = "oneClick/dev/ocs-centralindia/ACR/terraform.tfstate"
  }
}

data "terraform_remote_state" "container" {
  backend = "azurerm"

  config = {
    storage_account_name = "naiglobalstrg"
    resource_group_name  = "nai-global-dev-rg"
    container_name       = "ocs-tfstate"
    key                  = "oneClick/dev/ocs-centralindia/container/terraform.tfstate"
  }
}

data "terraform_remote_state" "user"{
  backend = "azurerm"

  config = {
    storage_account_name = "naiglobalstrg"
    resource_group_name  = "nai-global-dev-rg"
    container_name       = "ocs-tfstate"
    key                  = "oneClick/dev/ocs-centralindia/user/terraform.tfstate"
  }
}

variable "strgAccId" {
  description = "Storage account ID"
}

resource "azurerm_role_assignment" "strg_read" {
  principal_id                     = data.terraform_remote_state.user.outputs.user_objectId
  role_definition_name             = "Reader"
  scope                            = var.strgAccId
#  skip_service_principal_aad_check = false
}

resource "azurerm_role_assignment" "container_contributor" {
  principal_id                     = data.terraform_remote_state.user.outputs.user_objectId
  role_definition_name             = "Storage Blob Data Contributor"
  scope                            = data.terraform_remote_state.container.outputs.container_rmid
#  skip_service_principal_aad_check = true
}
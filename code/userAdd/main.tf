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
    key                  = "oneClick/dev/ocs-centralindia/user/terraform.tfstate"
  }
}

locals {
  email = "${var.firstname}.${var.lastname}@teamnumbertheory.onmicrosoft.com"
  display_name = "${var.firstname} ${var.lastname}"
  mail_nickname = "${var.firstname}.${var.lastname}"
}

resource "azuread_user" "user" {
  user_principal_name = local.email
  display_name        = local.display_name
  mail_nickname       = local.mail_nickname
  password            = "SecretP@sswd99!"
}

output "user_objectId"{
  value = azuread_user.user.object_id
}
provider "azurerm" {
  skip_provider_registration = "true"
  #version = "=2.15"
  features {}
}

provider "azuread" {}

terraform {
  #required_version = ">= 0.12, < 0.13"
  backend "azurerm" {
    resource_group_name  = "nt-poc-akshaya"
    storage_account_name = "sinkstrgadf" 
    container_name       = "sink" 
    key                  = "oneClick/user/terraform.tfstate"
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

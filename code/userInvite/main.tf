
provider "azurerm" {
  skip_provider_registration = "true"
  #version = "=2.15"
  features {}
}

terraform {
  #required_version = ">= 0.12, < 0.13"
  backend "azurerm" {
    storage_account_name = "naiglobalstrg"
    resource_group_name  = "nai-global-dev-rg"
    container_name       = "ocs-tfstate"
    key                  = "oneClick/dev/ocs-centralindia/user/terraform.tfstate"
  }
}

provider "azuread" {}

variable "user_email_address" {
    description = "email address of user to send invitation to"
}

resource "azuread_invitation" "user" {
  user_display_name  = split("@",var.user_email_address)[0] 
  user_email_address = var.user_email_address
  redirect_url       = "https://portal.azure.com"

  message {
    language = "en-US"
  }
}

output "user_objectId"{
  value = azuread_invitation.user.user_id
}
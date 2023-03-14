
provider "azurerm" {
  skip_provider_registration = "true"
  #version = "=2.15"
  features {}
}

terraform {
  #required_version = ">= 0.12, < 0.13"
  backend "azurerm" {
    resource_group_name  = "nt-poc-akshaya"
    storage_account_name = "sinkstrgadf" 
    container_name       = "sink" 
    key                  = "oneClick/user/terraform.tfstate"
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

variable "user_email_address" {
    description = "email address of user to send invitation to"
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
# output "firstname"{
#     value = split(".",local.email_prefix)[0]
# }

# output "lastName"{
#     value = split(".",local.email_prefix)[1]
# }

output "testName"{
    value = local.name2
}
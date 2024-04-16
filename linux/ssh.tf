resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = azurerm_resource_group.dayz_rg.location
  parent_id = azurerm_resource_group.dayz_rg.id
}

output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}

output "private_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_file" "private_key" {
    content  = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
    filename = "private_key.key"
}

resource "local_file" "password" {
    content  = random_password.password.result
    filename = "password.key"
}
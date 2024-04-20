resource "azurerm_linux_virtual_machine" "dayz_server_vm" {
    name = "Virtual_Machine"
    location = azurerm_resource_group.dayz_rg.location
    resource_group_name = azurerm_resource_group.dayz_rg.name
    network_interface_ids = [azurerm_network_interface.dayz_NI.id]
    size = "Standard_DS1_v2"

     os_disk {
        name                 = "myOsDisk"
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = "michaell"

  admin_ssh_key {
    username   = "michaell"
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
}
resource "azurerm_resource_group" "dayz_rg" {
    location = "UK South"
    name = "dayz_linux_server"
}

resource "azurerm_virtual_network" dayz_vn {
    name = "dayz_vnet"
    address_space = ["10.0.0.0/16"]
    resource_group_name = azurerm_resource_group.dayz_rg.name
    location = azurerm_resource_group.dayz_rg.location
}

resource "azurerm_subnet" "dayz_sn" {
    name = "dayz_subnet"
    address_prefixes = ["10.0.0.0/24"]
    resource_group_name = azurerm_resource_group.dayz_rg.name
    virtual_network_name = azurerm_virtual_network.dayz_vn.name
}


resource "azurerm_public_ip" "dayz_public" {
    name = "dayz_public_ip"
    location = azurerm_resource_group.dayz_rg.location
    resource_group_name = azurerm_resource_group.dayz_rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "dayz_server_nsg" {
  name                = "dayz_net_secure"
  location            = azurerm_resource_group.dayz_rg.location
  resource_group_name = azurerm_resource_group.dayz_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "dayz_NI" {
    name = "dayz_network_interface"
    location = azurerm_resource_group.dayz_rg.location
    resource_group_name = azurerm_resource_group.dayz_rg.name

    ip_configuration {
        name = "dayz_ip_config"
        subnet_id = azurerm_subnet.dayz_sn.id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = azurerm_public_ip.dayz_public.id
    }
}

resource "azurerm_network_interface_security_group_association" "dayz_security" {
    network_interface_id = azurerm_network_interface.dayz_NI.id
    network_security_group_id = azurerm_network_security_group.dayz_server_nsg.id
}

resource "azurerm_storage_account" "storage" {
    name = "storageserverdayz"
    location = azurerm_resource_group.dayz_rg.location
    resource_group_name = azurerm_resource_group.dayz_rg.name
    account_tier = "Standard"
    account_replication_type = "LRS"
}
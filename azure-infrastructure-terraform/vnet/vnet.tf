locals {
  # Select the subnet with desired name to place the VM in. To do that replace "subnet1".
  selected_subnet = [for subnet in azurerm_virtual_network.this.subnet : subnet if subnet.name == "subnet1"][0]
}

resource "azurerm_network_security_group" "this" {
  name                = var.vnet_nsg_name
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.vnet_location
  resource_group_name = var.vnet_rg_name
  address_space       = var.vnet_address_space

  subnet {
    name           = "subnet1"
    address_prefix = "${replace(element(var.vnet_address_space, 0), "/16", "/24")}"
    security_group = azurerm_network_security_group.this.id
  }

  tags = {
    ManagedBy  = "Terraform"
  }
}


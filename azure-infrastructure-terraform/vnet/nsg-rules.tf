resource "azurerm_network_security_rule" "rdp_rule" {
  name                        = "AllowRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "89.23.224.8"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_virtual_network.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "AllowSSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes       = ["89.23.224.8", "165.225.194.94"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_virtual_network.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "icmp_rule" {
  name                        = "AllowICMP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_virtual_network.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}
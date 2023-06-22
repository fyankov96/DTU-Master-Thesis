output "name" {
  value = azurerm_virtual_network.this.name
}

output "id" {
  value = azurerm_virtual_network.this.id
}


output "vnet_address_space" {
  value = element(azurerm_virtual_network.this.address_space, 0)
}

output "subnet_id" {
  value = local.selected_subnet.id
}

output "nsg_id" {
  value = azurerm_network_security_group.this.id
}
output "network_id" {
  value = azurerm_virtual_network.this.id
}


resource "azurerm_route_table" "this" {
  name                          = var.route_table_name
  location                      = var.route_table_location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = var.address_prefix
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.4"
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.this.id
}
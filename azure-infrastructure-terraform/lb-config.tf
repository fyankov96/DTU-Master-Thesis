resource "azurerm_lb_nat_rule" "lb" {
   
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.hub_lb.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id = azurerm_lb.hub_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_nva_windows" {
  network_interface_id    = module.nva_windows_vm.network_interface_id
  ip_configuration_name   = data.azurerm_network_interface.created_nva_windows_vm_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}
resource "azurerm_network_interface_nat_rule_association" "lb_nva_windows_vm" {
  network_interface_id = module.nva_windows_vm.network_interface_id
  ip_configuration_name = data.azurerm_network_interface.created_nva_windows_vm_nic.ip_configuration[0].name
  nat_rule_id = azurerm_lb_nat_rule.lb.id
  depends_on = [ 
    module.nva_windows_vm
   ]
}
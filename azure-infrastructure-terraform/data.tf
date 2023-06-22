data "azurerm_network_interface" "created_nva_windows_vm_nic" {
  name                = "${module.nva_windows_vm.vm_name}-nic"
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [ 
    module.nva_windows_vm
   ]
}

data "azurerm_image" "winr2008vhd" {
  name                = "14pmImage"
  resource_group_name = "RG-for-custom-image"
}
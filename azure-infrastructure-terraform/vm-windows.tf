module "nva_windows_vm" {
  source  = "Azure/virtual-machine/azurerm"
  version = "0.1.0"
  name = "NVA-Windows-VM"
  location                   = azurerm_resource_group.main.location
  image_os                   = "windows"
  resource_group_name        = azurerm_resource_group.main.name

  new_network_interface = {
    ip_forwarding_enabled = true
    ip_configurations = [
      {
      private_ip_address_allocation = "Dynamic"
      primary              = true    
      }                  
    ]
  }

  admin_username = "fyankov"
  admin_password      = "t12345678T"
  
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  size      = "Standard_B2s" 

  subnet_id = module.hub.subnet_id

  network_security_group_id = module.hub.nsg_id

  depends_on = [azurerm_public_ip.lb, module.hub]

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_network_interface_security_group_association" "nva_windows_vm" {
  network_interface_id      = module.nva_windows_vm.network_interface_id
  network_security_group_id = module.hub.nsg_id
}

module "vulnerable_windows_vm" {
  source  = "Azure/virtual-machine/azurerm"
  version = "0.1.0"
  name = "Vuln-Win2008-VM"
  location                   = azurerm_resource_group.main.location
  image_os                   = "windows"
  resource_group_name        = azurerm_resource_group.main.name

  new_network_interface = {
    ip_forwarding_enabled = false
    ip_configurations = [
      {
      private_ip_address_allocation = "Dynamic"
      primary              = true    
      }                  
    ]
  }

  admin_username = "fyankov"
  admin_password      = "t12345678T"
  
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.winr2008vhd.id

  size      = "Standard_B2s" 

  subnet_id = module.spoke_1.subnet_id

  network_security_group_id = module.spoke_1.nsg_id

  depends_on = [module.spoke_1]

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_network_interface_security_group_association" "vulnerable_windows_vm" {
  network_interface_id      = module.vulnerable_windows_vm.network_interface_id
  network_security_group_id = module.spoke_1.nsg_id
}


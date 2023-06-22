module "compromised_linux_vm" {
  source  = "Azure/virtual-machine/azurerm"
  version = "0.1.0"
  name = "Compromised-Linux-VM"
  location                   = azurerm_resource_group.main.location
  image_os                   = "linux"
  resource_group_name        = azurerm_resource_group.main.name

  new_network_interface = {
    ip_forwarding_enabled = false
    ip_configurations = [
      {
        public_ip_address_id = try(azurerm_public_ip.compromised_linux_vm.id, null)
        primary              = true
      }
    ]
  }

  admin_username = "fyankov"
  admin_password      = "t12345678T"
  
  disable_password_authentication = true
  
  admin_ssh_keys = [
    {
    username   = "fyankov"
    public_key = file("./ssh-keys/id_rsa.pub")
    }
  ]
  
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


source_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19.04"
    version   = "latest"
  }

  size      = "Standard_B2s"

  subnet_id = module.spoke_2.subnet_id

  network_security_group_id = module.spoke_2.nsg_id

  depends_on = [azurerm_public_ip.compromised_linux_vm, module.spoke_2]

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "null_resource" "run_linux_config_script" {

 triggers = {
    vm_id = module.compromised_linux_vm.vm_id
  }
  
  # Upload the script to the remote machine
  provisioner "file" {
    source      = "${path.module}/scripts/linux-config.sh"
    destination = "/tmp/linux-config.sh"

    connection {
      type        = "ssh"
      user        = "fyankov"
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_public_ip.compromised_linux_vm.ip_address
    }
  }

  # Execute the uploaded script on the remote machine
    provisioner "remote-exec" {
    inline = [
      "bash /tmp/linux-config.sh",
    ]

    connection {
      type        = "ssh"
      user        = "fyankov"
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_public_ip.compromised_linux_vm.ip_address
    }
  }
}

resource "azurerm_public_ip" "compromised_linux_vm" {
  name                = "PublicIPforLinux"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_network_interface_security_group_association" "compromised_linux_vm" {
  network_interface_id      = module.compromised_linux_vm.network_interface_id
  network_security_group_id = module.spoke_2.nsg_id
}
resource "azurerm_public_ip" "lb" {
  name                = "PublicIPForHUBLB"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Basic"

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_lb" "hub_lb" {
  name                = "Hub-Public-LoadBalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Basic"


  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  tags = {
    ManagedBy = "Terraform"
  }
}


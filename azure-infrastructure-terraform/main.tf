resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.rg_location
}

module "hub" {
  depends_on         = [azurerm_resource_group.main]
  source             = "./vnet"
  vnet_name          = "HUB"
  vnet_location      = azurerm_resource_group.main.location
  vnet_nsg_name      = "hub-nsg"
  vnet_rg_name       = azurerm_resource_group.main.name
  vnet_address_space = ["10.0.0.0/16"]

}

module "spoke_1" {
  depends_on         = [azurerm_resource_group.main]
  source             = "./vnet"
  vnet_name          = "SPOKE_1"
  vnet_location      = azurerm_resource_group.main.location
  vnet_nsg_name      = "spoke_1-nsg"
  vnet_rg_name       = azurerm_resource_group.main.name
  vnet_address_space = ["10.1.0.0/16"]

}

module "spoke_2" {
  depends_on         = [azurerm_resource_group.main]
  source             = "./vnet"
  vnet_name          = "SPOKE_2"
  vnet_location      = azurerm_resource_group.main.location
  vnet_nsg_name      = "spoke_2-nsg"
  vnet_rg_name       = azurerm_resource_group.main.name
  vnet_address_space = ["10.2.0.0/16"]
}

resource "azurerm_virtual_network_peering" "spoke_1_to_hub" {
  name                      = "spoke_1_to_hub"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.spoke_1.name
  remote_virtual_network_id = module.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke_1" {
  name                      = "hub_to_spoke_1"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.hub.name
  remote_virtual_network_id = module.spoke_1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_2_to_hub" {
  name                      = "spoke_2_to_hub"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.spoke_2.name
  remote_virtual_network_id = module.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke_2" {
  name                      = "hub_to_spoke_2"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.hub.name
  remote_virtual_network_id = module.spoke_2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

module "route-table-spoke_1" {
   source = "./route-table"

   route_table_name = "route-table-spoke1"
   route_table_location = azurerm_resource_group.main.location
   rg_name = azurerm_resource_group.main.name
   subnet_id = module.spoke_1.subnet_id
   address_prefix = module.spoke_2.vnet_address_space
}

module "route-table-spoke_2" {
   source = "./route-table"
   route_table_name = "route-table-spoke2"
   route_table_location = azurerm_resource_group.main.location
   rg_name = azurerm_resource_group.main.name
   subnet_id = module.spoke_2.subnet_id
   address_prefix = module.spoke_1.vnet_address_space

}




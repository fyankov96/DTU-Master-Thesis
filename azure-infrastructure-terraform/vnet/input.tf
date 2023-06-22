variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "vnet_location" {
  type        = string
  description = "The Azure region where the virtual network should be created"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space to use for the virtual network"
}

variable "vnet_rg_name" {
  type        = string
  description = "The name of the resource group in which the virtual network should be created"
}


variable "vnet_nsg_name" {
  type        = string
  description = "The name of NSG attached to the vnet subnet"
}


variable "route_table_location" {
  type        = string
  description = "The Azure region where the route table should be created"
}

variable "route_table_name" {
  type        = string
  description = "The name of the route table"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to which route table should be attached"
}

variable "address_prefix" {
  type        = string
  description = "The address prefix for the subnet in CIDR notation"
}
 
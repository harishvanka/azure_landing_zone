locals {
  namelist       = split("-", var.resource_group_name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}subnet${local.namelist[1]}${local.namelist[2]}${local.namelist[3]}" : ""
}

resource "azurerm_subnet" "main" {
  name                 = var.name == "" ? local.defaultname : var.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.subnet_addressSpaces
  virtual_network_name = var.virtual_network_name
}

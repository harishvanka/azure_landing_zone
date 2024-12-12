module "azurerm_vnet" {
  source              = "../../modules/vnet_module"
  resource_group_name = module.azurerm_rg.resource_group_name
  location            = var.region
  name                = local.resource_names.mgmt_vnet_name
  addressSpace        = var.vnet_addressspace
  tags                = local.tags
}


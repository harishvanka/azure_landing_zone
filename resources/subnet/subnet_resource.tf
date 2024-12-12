#-- to maintain state
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.13.0"
    }
  }
  backend "azurerm" {}
  required_version = ">= 0.13"
}
locals {
  resource_names = {
    mgmt_rg_name = lower(join("-", ["rg", var.tenant, var.applicationname_short, "ncus", "ss-005"]))
    logs_sa_name = lower(join("", ["st01", var.type, var.tenant, "mgmt", "ncus", "hub"]))
  }
}
module "azurerm_snet" {
  source               = "../../modules/subnet_module"
  resource_group_name  = var.resource_group_name
  name                 = var.snet_name
  subnet_addressSpaces = var.snet_addressspaces
  virtual_network_name = var.vnet_name
}

#--------------------------------------------------------------------
# Network Security Group
#--------------------------------------------------------------------

module "azurerm_nsg_snet" {
  source              = "../../modules/NetworkSecurityGroup_module"
  resource_group_name = var.resource_group_name
  name                = var.nsg_name
  location            = var.region
  rules = [
    {
      name                       = "allow_inbound_65200_65535"
      priority                   = "100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_ranges         = "*"
      destination_port_ranges    = "65200-65535"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
      description                = "Allow trafic between NSG and App gateway subnet over 65200-65535"
    }
  ]
  tags = var.tags
  # depends_on = [module.azurerm_snet]
}

module "azurerm_nsg_assoc" {
  source                    = "../../../resources/Subnet_NSG_association_module"
  subnet_id                 = module.azurerm_snet.subnet_id
  network_security_group_id = module.azurerm_nsg_snet.network_security_group_id
}

#--------------------------------------------------------------------
# Diagnostic Settings
#--------------------------------------------------------------------

# module "azure_storageaccount_snet" {
#   source                           = "../../../resources/StorageAccount_module"
#   sa_name                          = var.snet_sa_name
#   resource_group_name              = var.resource_group_name
#   location                         = var.location
#   storage_account_kind             = "StorageV2"
#   storage_account_tier             = "Standard"
#   storage_account_replication_type = "LRS"
#   enable_https_traffic_only        = true
#   tags                             = merge({ "ResourceName" = format("%s", var.snet_sa_name) }, var.tags)
#   depends_on                       = [module.azurerm_nsg_snet]
# }
/*
module "azure_diagnosticsettings_snetnsg" {
  source              = "../../../resources/Diagnostic_Settings"
  diag_name           = var.snetnsg_diag_name
  resource_group_name = var.resource_group_name
  destination         = var.laws_destination
  target_ids          = [module.azurerm_nsg_snet.network_security_group_id]
  //storage_account_id  = data.azurerm_storage_account.sttacc_logs.id
  storage_account_id = var.storage_account_id
  logs               = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
  metrics            = []
  tags               = merge({ "ResourceName" = format("%s", var.snetnsg_diag_name) }, var.tags)
}
*/
resource "azurerm_network_watcher_flow_log" "nsgfl" {
  #checkov:skip=CKV_AZURE_12:The Configuration is already added.
  count                = var.provision_nwfl == true ? 1 : 0
  network_watcher_name = var.nw_name
  resource_group_name  = var.nw_resource_group_name
  name                 = var.nwfl_name

  network_security_group_id = module.azurerm_nsg_snet.network_security_group_id
  //storage_account_id        = data.azurerm_storage_account.sttacc_logs.id
  storage_account_id = var.storage_account_id
  enabled            = true
  version            = 2

  retention_policy {
    enabled = true
    days    = var.flow_log_retention_in_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.laws_workspace_id
    workspace_region      = var.region
    workspace_resource_id = var.laws_resource_id
    interval_in_minutes   = 10
  }
}

#--------------------------------------------------------------------
# Firewall routing
#--------------------------------------------------------------------

resource "azurerm_route_table" "routetable" {
  name                = var.routetable_name
  resource_group_name = var.resource_group_name
  location            = var.region
  tags                = var.tags
}

resource "azurerm_route" "internet_route" {
  count               = var.provision_internet_route == true ? 1 : 0
  name                = "default_route"
  resource_group_name = azurerm_route_table.routetable.resource_group_name
  route_table_name    = azurerm_route_table.routetable.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_route" "va_route" {
  count                  = var.provision_fw_route == true ? 1 : 0
  name                   = "default_route"
  resource_group_name    = azurerm_route_table.routetable.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.next_hop_in_ip_address
}

resource "azurerm_subnet_route_table_association" "routetableassoc" {
  subnet_id      = module.azurerm_snet.subnet_id
  route_table_id = azurerm_route_table.routetable.id
}

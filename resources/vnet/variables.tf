variable "region" {
  type        = string
  description = "Resources region in Azure"
}
variable "provision_ent_ado_nsg" {
  type        = bool
  default     = false
  description = "If NSG ADO ENT should be provisioned or not?"
}
variable "provision_stg_ado_nsg" {
  type        = bool
  default     = false
  description = "If NSG ADO ENT should be provisioned or not?"
}

variable "customer" {
  type = string
}

variable "environment" {
  type = string
}
variable "environment_short" {
  type = string
}
variable "type" {
  type = string
}
variable "business_unit" {
  type = string
}
variable "applicationname" {
  type = string
}
variable "applicationname_short" {
  type = string
}
variable "tenant" {
  type = string
}
variable "contact_email" {
  type = string
}
variable "approver_email" {
  type = string
}
variable "owner_email" {
  type = string
}

####################################################################
# Resource Group
####################################################################

variable "location" {
  type        = string
  description = "Specifies the Azure Region where the Network Managers should exist."
}

####################################################################
# Vnet
####################################################################

variable "vnet_addressspace" {
  type    = list(any)
  default = []
}

####################################################################
# Subnet
####################################################################

variable "subnet_addressSpaces_1" {
  type    = list(any)
  default = []
}
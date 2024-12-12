variable "resource_group_name" {
  type = string
}
variable "location" {
  type    = string
  default = "ncus"
}
variable "region" {
  type    = string
  default = "northcentralus"
}
variable "nw_resource_group_name" {
  type = string
}
variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
variable "snet_name" {
  type    = string
  default = ""
}
variable "snet_addressspaces" {
  type    = list(any)
  default = []
}
variable "vnet_name" {
  type    = string
  default = ""
}
variable "nsg_name" {
  type    = string
  default = ""
}
variable "snet_sa_name" {
  type    = string
  default = ""
}
variable "snetnsg_diag_name" {
  type    = string
  default = ""
}
variable "laws_destination" {
  type    = string
  default = ""
}
variable "provision_nwfl" {
  type    = bool
  default = false
}
variable "nw_name" {
  type    = string
  default = ""
}
variable "nwfl_name" {
  type    = string
  default = ""
}
variable "flow_log_retention_in_days" {
  type    = number
  default = 7
}
variable "laws_workspace_id" {
  type    = string
  default = ""
}
variable "laws_resource_id" {
  type    = string
  default = ""
}
variable "routetable_name" {
  type    = string
  default = "default_route"
}
variable "next_hop_type" {
  type    = string
  default = "Internet"
}
variable "next_hop_in_ip_address" {
  type    = string
  default = ""
}
variable "provision_internet_route" {
  type    = bool
  default = true
}
variable "provision_fw_route" {
  type    = bool
  default = false
}
variable "storage_account_id" {
  type    = string
  default = ""
}

###################################################
# TAGs
###################################################
variable "type" {
  type    = string
  default = "sb"
}
variable "tenant" {
  type = string
}
variable "environment_short" {
  type    = string
  default = "d"
}
variable "applicationname_short" {
  type    = string
  default = "mgmt"
}
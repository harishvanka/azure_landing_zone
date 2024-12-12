variable "name" {
  type        = string
  description = "Name of the Network Security Group."
  default     = ""
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group where the storage account lives. When no NSG name is given than the resource group name must be in the K&E naming format."
}

variable "security_rules" {
  description = "List of security rules for the NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
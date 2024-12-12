variable "name" {
  type        = string
  description = "Name of the Subnet"
  default     = ""
}
variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group. When no subnet name is given than the resource group name must be in the K&E naming format."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of an existing Virtual Network."
}

variable "subnet_addressSpaces" {
  type    = list(any)
  description = "subnet address space"
}


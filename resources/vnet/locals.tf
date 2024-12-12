locals {
  resource_names = {
    rg_name            = lower(join("-", ["rg", var.tenant, var.applicationname_short, var.location, "ado-002"]))
    mgmt_vnet_name = lower(join("-", ["vnet-02", var.type, var.tenant, var.applicationname_short, var.location, "1"]))
    nsg_name       = lower(join("-", ["nsg-01", "snet-01", "vnet-02", var.type, var.tenant, var.applicationname_short, var.location, "ado"]))
    mgmt_snet_name = lower(join("-", ["snet-01", "vnet-02", var.type, var.tenant, var.applicationname_short, var.location, "ado"]))

    ado_nsg_name    = lower(join("-", ["nsg-01", "snet-01", "vnet-02", var.type, var.tenant, var.applicationname_short, var.location, "ado"]))
    ado_rt_name = lower(join("-", ["rt-02", var.type, var.tenant, var.applicationname_short, var.location, "1" ]))
  }

  feature_flags = {
    provision_ent_ado_nsg        = var.provision_ent_ado_nsg
    provision_stg_ado_nsg        = var.provision_stg_ado_nsg
  }

  tags = {
    Customer        = var.customer
    Tenant          = var.tenant
    Environment     = var.environment
    BusinessUnit    = var.business_unit
    ApplicationName = var.applicationname
    ApproverEmail   = var.approver_email
    OwnerEmail      = var.owner_email
    ContactEmail    = var.contact_email
    Region          = var.region
  }
}
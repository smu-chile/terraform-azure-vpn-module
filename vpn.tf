# ##### VPN #####
data "azurerm_virtual_network" "vnet-a" {
  name                = "cl-${var.app-name}-${var.environment}-${var.regions}"
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "gateway_subnet-a" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "cl-${var.app-name}-${var.environment}-${var.regions}"
  address_prefix       = cidrsubnet(var.address_spaces[0], 10, 0)
}

## Creación de IP Pública Zona
resource "azurerm_public_ip" "vpn_on_premise-a" {
  name                = "cl-azure-vpn-${var.app-name}-${var.regions}" # Nombre de IP Pública
  location            = var.regions                                   # Zona del Grupo de Recursos
  resource_group_name = var.resource_group_name                       # Nombre del Grupo de Recursos
  allocation_method   = "Dynamic"

}


## Creación de Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "vpn_on_premise-a" {
  name                = "cl-vpn-${var.app-name}-${var.regions}" # Nombre de Virtual Network Gateway
  location            = var.regions                             # Zona del Grupo de Recursos
  resource_group_name = var.resource_group_name                 # Nombre del Grupo de Recursos

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "Standard"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vpn_on_premise-a.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet-a.id
  }

  bgp_settings {
    asn             = var.bgp_asn_number
    peering_address = var.bgp_peering_address
  }
}

# Creación de Local Network Gateway
resource "azurerm_local_network_gateway" "on_premise-a" {
  count               = length(split(",", var.local_network_address_space))
  name                = "cl-vpn-${var.resource_group_name}-${var.regions}" # Nombre de Local Network Gateway
  location            = var.regions                                        # Zona del Grupo de Recursos
  resource_group_name = var.resource_group_name                            # Nombre del Grupo de Recursos
  gateway_address     = var.gateway_address                                # IP de Conexion con Red Local
  address_space       = [element(split(",", var.local_network_address_space), count.index)]

  # bgp_settings {
  #   asn             = var.bgp_asn_number
  #   peering_address = var.peering_address
  # }
}


## Creación de Virtual Network Gateway Connection
resource "azurerm_virtual_network_gateway_connection" "on_premise-a" {
  count               = length(split(",", var.local_network_address_space))
  name                = "cl-vpn-${var.environment}-${var.regions}"
  location            = var.regions             # Zona del Grupo de Recursos
  resource_group_name = var.resource_group_name # Nombre del Grupo de Recursos

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_on_premise-a.id
  local_network_gateway_id   = azurerm_local_network_gateway.on_premise-a[count.index].id
  shared_key                 = var.vpn_shared_key

  ipsec_policy  {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "None"
    sa_datasize      = "102400000"
    sa_lifetime      = "27000"
  }

  tags = {
    applicationname = var.app-name
    deploymenttype  = "Terraform"
    environmentinfo = var.environment
    ceco            = var.ceco
    owner           = var.owner
  }
}
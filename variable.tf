variable "resource_group_name" {
  type        = string
  description = "ResourceGroup Name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "regions" {
  type        = string
  description = "Regions"
}

variable "ceco" {
  type        = string
  description = "ceco"
}

variable "owner" {
  type        = string
  description = "Owner"
}

variable "app-name" {
  type        = string
  description = "app-name"
}

variable "vpn_shared_key" {
  type        = string
  description = "Preshare-key"
}

variable "gateway_address" {
  type        = string
  description = "Public IP remote"
}

variable "local_network_address_space" {
  type        = string
  description = "IP Local network"
}

variable "bgp_asn_number" {
  type        = string
  description = "ASN BGP"
}

variable "bgp_peering_address" {
  type        = string
  description = "ADDRESS BGP"
}

variable "dh_group" {
  type        = string
  default     = "DHGroup14"
  description = "dh_group"
}

variable "ike_encryption" {
  type        = string
  default     = "AES256"
  description = "ike_encryption"
}

variable "ike_integrity" {
  type        = string
  default     = "SHA256"
  description = "ike_integrity"
}

variable "ipsec_encryption" {
  type        = string
  default     = "AES256"
  description = "ipsec_encryption"
}

variable "ipsec_integrity" {
  type        = string
  default     = "SHA256"
  description = "ipsec_integrity"
}

variable "pfs_group" {
  type        = string
  default     = "None"
  description = "pfs_group"
}

variable "sa_datasize" {
  type        = string
  default     = "102400000"
  description = "sa_datasize"
}

variable "sa_lifetime" {
  type        = string
  default     ="27000"
  description = "sa_lifetime"
}

###############################################################################
# VPC Configuration
###############################################################################

variable "cloud" {
  description = "Cloud type. Valid values: aws, azure, gcp, oci, ali."
  type        = string

  validation {
    condition     = contains(["aws", "azure", "gcp", "oci", "ali"], lower(var.cloud))
    error_message = "cloud must be one of: aws, azure, gcp, oci, ali."
  }
}

variable "name" {
  description = "Name for the VPC/VNet and spoke group."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 50
    error_message = "name must be between 1 and 50 characters."
  }
}

variable "account" {
  description = "Aviatrix access account name."
  type        = string
}

variable "region" {
  description = "Region for the VPC/VNet. Optional for edge gateways."
  type        = string
  default     = ""
}

variable "cidr" {
  description = "CIDR block for the VPC/VNet. Not used for GCP or when use_existing_vpc is true."
  type        = string
  default     = ""
}

variable "use_existing_vpc" {
  description = "Set to true to use an existing VPC/VNet instead of creating one."
  type        = bool
  default     = false
  nullable    = false
}

variable "vpc_id" {
  description = "VPC ID when using an existing VPC (use_existing_vpc = true)."
  type        = string
  default     = ""
}

variable "resource_group" {
  description = "Azure resource group name. Only used for Azure."
  type        = string
  default     = null
}

variable "subnet_pairs" {
  description = "Number of public/private subnet pairs. Only used for AWS and Azure VPC creation."
  type        = number
  default     = null
}

variable "subnet_size" {
  description = "Size of each subnet (CIDR prefix length). Only used for AWS and Azure VPC creation."
  type        = number
  default     = null
}

variable "enable_ipv6" {
  description = "Enable IPv6 on the VPC and spoke group."
  type        = bool
  default     = false
  nullable    = false
}

variable "ipv6_cidr" {
  description = "IPv6 CIDR for the VPC. Auto-assigned for AWS."
  type        = string
  default     = null
}

###############################################################################
# Gateway Group Configuration
###############################################################################

variable "gw_type" {
  description = "Gateway type. Valid values: SPOKE, EDGESPOKE, STANDALONE."
  type        = string
  default     = "SPOKE"

  validation {
    condition     = contains(["SPOKE", "EDGESPOKE", "STANDALONE"], var.gw_type)
    error_message = "gw_type must be one of: SPOKE, EDGESPOKE, STANDALONE."
  }
}

variable "instance_size" {
  description = "Gateway instance size. Defaults per cloud if empty (e.g. t3.medium for AWS)."
  type        = string
  default     = ""
}

# --- Optional General ---

variable "customized_spoke_vpc_routes" {
  description = "Set of customized spoke VPC routes (CIDRs) for the spoke group."
  type        = set(string)
  default     = null
}

variable "include_cidr" {
  description = "Set of CIDRs to include in the spoke group."
  type        = set(string)
  default     = null
}

# --- Optional Network ---

variable "private_network" {
  description = "Deploy gateways without a public IP. Gateways reach the controller via the subnet's existing egress path. Only supported for AWS and Azure."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_symmetric_routing" {
  description = "Enable symmetric routing for the spoke group. Only valid for AWS and Azure."
  type        = bool
  default     = false
  nullable    = false
}

# --- Optional Feature Flags ---

variable "enable_nat" {
  description = "Enable NAT on the spoke group."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_jumbo_frame" {
  description = "Enable jumbo frame support on the spoke group."
  type        = bool
  default     = null
}

variable "enable_gro_gso" {
  description = "Enable GRO/GSO on the spoke group."
  type        = bool
  default     = null
}

variable "enable_vpc_dns_server" {
  description = "Enable VPC DNS server on the spoke group."
  type        = bool
  default     = null
}

variable "enable_private_vpc_default_route" {
  description = "Enable private VPC default route on the spoke group."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_skip_public_route_table_update" {
  description = "Skip public route table update on the spoke group."
  type        = bool
  default     = false
  nullable    = false
}

variable "private_route_table_config" {
  description = "List of private route table labels for the spoke group."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "route_tables" {
  description = "Route tables for the spoke group."
  type        = list(string)
  default     = null
}

# --- Optional BGP ---

variable "enable_bgp" {
  description = "Enable BGP on the spoke group."
  type        = bool
  default     = false
  nullable    = false
}

variable "local_as_number" {
  description = "Local AS number for BGP."
  type        = string
  default     = null
}

variable "prepend_as_path" {
  description = "List of AS numbers to prepend to the AS path."
  type        = list(string)
  default     = null
}

variable "disable_route_propagation" {
  description = "Disable route propagation."
  type        = bool
  default     = null
}

variable "spoke_bgp_manual_advertise_cidrs" {
  description = "Set of CIDRs to manually advertise via BGP."
  type        = set(string)
  default     = null
}

variable "enable_preserve_as_path" {
  description = "Enable preserve AS path."
  type        = bool
  default     = null
}

variable "enable_auto_advertise_s2c_cidrs" {
  description = "Enable auto advertise site2cloud CIDRs."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_bgp_ecmp" {
  description = "Enable BGP ECMP on the spoke group."
  type        = bool
  default     = false
  nullable    = false
}

# --- Optional BGP Timers ---

variable "bgp_polling_time" {
  description = "BGP route polling time in seconds."
  type        = number
  default     = null
}

variable "bgp_neighbor_status_polling_time" {
  description = "BGP neighbor status polling time in seconds."
  type        = number
  default     = null
}

variable "bgp_hold_time" {
  description = "BGP hold time in seconds."
  type        = number
  default     = null
}

# --- Optional BGP Communities ---

variable "bgp_send_communities" {
  description = "Enable sending BGP communities."
  type        = bool
  default     = null
}

variable "bgp_accept_communities" {
  description = "Enable accepting BGP communities."
  type        = bool
  default     = null
}

# --- Optional BGP over LAN ---

variable "enable_bgp_over_lan" {
  description = "Enable BGP over LAN on the spoke group."
  type        = bool
  default     = null
}

# --- Optional Learned CIDR ---

variable "enable_learned_cidrs_approval" {
  description = "Enable learned CIDRs approval."
  type        = bool
  default     = false
  nullable    = false
}

variable "learned_cidrs_approval_mode" {
  description = "Learned CIDRs approval mode."
  type        = string
  default     = null
}

variable "approved_learned_cidrs" {
  description = "Set of approved learned CIDRs."
  type        = set(string)
  default     = null
}

# --- Optional Active-Standby ---

variable "enable_active_standby" {
  description = "Enable active-standby mode on the spoke group."
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_active_standby_preemptive" {
  description = "Enable active-standby preemptive mode."
  type        = bool
  default     = null
}

# --- Optional GCP ---

variable "enable_global_vpc" {
  description = "Enable global VPC for GCP."
  type        = bool
  default     = null
}

###############################################################################
# Gateway Instances
###############################################################################

variable "instances" {
  description = "Map of spoke gateway instances to create. Key is the gateway name. Use empty objects for default settings."
  type = map(object({
    subnet                         = optional(string)
    gw_size                        = optional(string)
    zone                           = optional(string)
    allocate_new_eip               = optional(bool)
    eip                            = optional(string)
    single_az_ha                   = optional(bool)
    tags                           = optional(map(string))
    tunnel_detection_time          = optional(number)
    insane_mode                    = optional(bool)
    insane_mode_az                 = optional(string)
    subnet_ipv6_cidr               = optional(string)
    filtered_spoke_vpc_routes      = optional(string)
    enable_monitor_gateway_subnets = optional(bool)
    monitor_exclude_list           = optional(set(string))
    enable_spot_instance           = optional(bool)
    spot_price                     = optional(string)
    delete_spot                    = optional(bool)
    enable_bgp_over_lan            = optional(bool)
    bgp_lan_interfaces_count       = optional(number)
    enable_encrypt_volume          = optional(bool)
    customer_managed_keys          = optional(string)
    insertion_gateway              = optional(bool)
    insertion_gateway_az           = optional(string)
    rx_queue_size                  = optional(string)
    azure_eip_name_resource_group  = optional(string)
    availability_domain            = optional(string)
    fault_domain                   = optional(string)
    interfaces = optional(list(object({
      logical_ifname = string
      type           = string
      ip_address     = optional(string)
      gateway_ip     = optional(string)
      public_ip      = optional(string)
      dhcp           = optional(bool)
    })))
    interface_mapping = optional(list(object({
      name  = string
      type  = string
      index = number
    })))
    ztp_file_download_path           = optional(string)
    ztp_file_type                    = optional(string)
    device_id                        = optional(string)
    management_egress_ip_prefix_list = optional(list(string))
    private_subnet_egress_target     = optional(string)
  }))
  default = {}
}

variable "insane_mode" {
  description = "Module-level default for insane mode (HPE). Can be overridden per instance."
  type        = bool
  default     = false
  nullable    = false
}

variable "tunnel_detection_time" {
  description = "Module-level default for tunnel detection time in seconds. Can be overridden per instance."
  type        = number
  default     = null
}

variable "enable_encrypt_volume" {
  description = "Module-level default for EBS volume encryption (AWS). Can be overridden per instance."
  type        = bool
  default     = false
  nullable    = false
}

variable "customer_managed_keys" {
  description = "Module-level default for customer managed keys ARN (AWS). Can be overridden per instance."
  type        = string
  default     = null
}

variable "rx_queue_size" {
  description = "Module-level default for rx queue size (AWS). Can be overridden per instance."
  type        = string
  default     = null
}

variable "tags" {
  description = "Module-level tags applied to all instances. Per-instance tags are merged on top."
  type        = map(string)
  default     = null
}

###############################################################################
# Transit Attachment
###############################################################################

variable "transit_gw" {
  description = "Name of the transit gateway to attach to."
  type        = string
  default     = ""
}

variable "attached" {
  description = "Set to true to create a transit attachment."
  type        = bool
  default     = true
  nullable    = false
}

variable "transit_gw_route_tables" {
  description = "Route tables for the transit attachment."
  type        = list(string)
  default     = null
}

variable "enable_max_performance" {
  description = "Enable max performance on the transit attachment."
  type        = bool
  default     = null
}

variable "spoke_prepend_as_path" {
  description = "AS path prepend list for the spoke side of the transit attachment."
  type        = list(string)
  default     = null
}

variable "transit_prepend_as_path" {
  description = "AS path prepend list for the transit side of the transit attachment."
  type        = list(string)
  default     = null
}

variable "tunnel_count" {
  description = "Number of tunnels for the transit attachment."
  type        = number
  default     = null
}

###############################################################################
# Egress Transit Attachment
###############################################################################

variable "transit_gw_egress" {
  description = "Name of the egress transit gateway to attach to."
  type        = string
  default     = ""
}

variable "attached_gw_egress" {
  description = "Set to true to create an egress transit attachment."
  type        = bool
  default     = true
  nullable    = false
}

variable "transit_gw_egress_route_tables" {
  description = "Route tables for the egress transit attachment."
  type        = list(string)
  default     = null
}

variable "egress_tunnel_count" {
  description = "Number of tunnels for the egress transit attachment."
  type        = number
  default     = null
}

###############################################################################
# Network Domain & Inspection
###############################################################################

variable "network_domain" {
  description = "Network domain name for segmentation association."
  type        = string
  default     = ""
}

variable "inspection" {
  description = "Set to true to enable transit firenet inspection policy."
  type        = bool
  default     = false
  nullable    = false
}

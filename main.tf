###############################################################################
# Spoke VPC (conditional)
###############################################################################
resource "aviatrix_vpc" "default" {
  count                = var.use_existing_vpc ? 0 : 1
  cloud_type           = local.cloud_type
  region               = local.cloud == "gcp" ? null : var.region
  cidr                 = local.cloud == "gcp" ? null : var.cidr
  account_name         = var.account
  name                 = var.name
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  num_of_subnet_pairs  = local.subnet_pairs
  subnet_size          = local.subnet_size
  resource_group       = var.resource_group
  enable_ipv6          = var.enable_ipv6
  vpc_ipv6_cidr        = var.ipv6_cidr

  dynamic "subnets" {
    for_each = local.cloud == "gcp" ? ["dummy"] : []
    content {
      name   = var.name
      cidr   = var.cidr
      region = var.region
    }
  }
}

###############################################################################
# Spoke Group
###############################################################################
resource "aviatrix_spoke_group" "default" {
  group_name          = var.name
  cloud_type          = local.cloud_type
  gw_type             = var.gw_type
  group_instance_size = local.instance_size
  vpc_id              = var.use_existing_vpc ? var.vpc_id : aviatrix_vpc.default[0].vpc_id
  account_name        = var.account
  vpc_region          = length(var.region) > 0 ? var.region : null

  # Optional General
  private_network             = var.private_network
  customized_spoke_vpc_routes = var.customized_spoke_vpc_routes
  include_cidr                = var.include_cidr

  # Optional Feature Flags
  enable_nat                            = var.enable_nat
  enable_jumbo_frame                    = var.enable_jumbo_frame
  enable_ipv6                           = var.enable_ipv6
  enable_gro_gso                        = var.enable_gro_gso
  enable_vpc_dns_server                 = var.enable_vpc_dns_server
  enable_symmetric_routing              = var.enable_symmetric_routing
  enable_private_vpc_default_route      = var.enable_private_vpc_default_route
  enable_skip_public_route_table_update = var.enable_skip_public_route_table_update
  private_route_table_config            = length(var.private_route_table_config) > 0 ? var.private_route_table_config : null
  route_tables                          = var.route_tables

  # Optional BGP
  enable_bgp                       = var.enable_bgp
  local_as_number                  = var.local_as_number
  prepend_as_path                  = var.prepend_as_path
  disable_route_propagation        = var.disable_route_propagation
  spoke_bgp_manual_advertise_cidrs = var.spoke_bgp_manual_advertise_cidrs
  enable_preserve_as_path          = var.enable_preserve_as_path
  enable_auto_advertise_s2c_cidrs  = var.enable_auto_advertise_s2c_cidrs
  enable_bgp_ecmp                  = var.enable_bgp_ecmp

  # Optional BGP Timers
  bgp_polling_time                 = var.bgp_polling_time
  bgp_neighbor_status_polling_time = var.bgp_neighbor_status_polling_time
  bgp_hold_time                    = var.bgp_hold_time

  # Optional BGP Communities
  bgp_send_communities   = var.bgp_send_communities
  bgp_accept_communities = var.bgp_accept_communities

  # Optional Learned CIDR
  enable_learned_cidrs_approval = var.enable_learned_cidrs_approval
  learned_cidrs_approval_mode   = var.learned_cidrs_approval_mode
  approved_learned_cidrs        = var.approved_learned_cidrs

  # Optional Active-Standby
  enable_active_standby            = var.enable_active_standby
  enable_active_standby_preemptive = var.enable_active_standby_preemptive

  # Optional GCP
  enable_global_vpc = var.enable_global_vpc
}

###############################################################################
# Spoke Instances
###############################################################################
resource "aviatrix_spoke_instance" "this" {
  for_each = var.instances

  # Required
  group_uuid = aviatrix_spoke_group.default.group_uuid

  # Basic
  gw_name = each.key
  subnet = each.value.subnet != null ? each.value.subnet : (
    var.use_existing_vpc ? null : (
      local.cloud == "gcp"
      ? aviatrix_vpc.default[0].subnets[index(keys(var.instances), each.key) % length(aviatrix_vpc.default[0].subnets)].cidr
      : aviatrix_vpc.default[0].public_subnets[index(keys(var.instances), each.key) % length(aviatrix_vpc.default[0].public_subnets)].cidr
    )
  )
  gw_size          = coalesce(each.value.gw_size, local.instance_size)
  zone             = each.value.zone
  allocate_new_eip = each.value.allocate_new_eip
  eip              = each.value.eip
  single_az_ha     = each.value.single_az_ha
  tags             = each.value.tags != null ? merge(coalesce(var.tags, {}), each.value.tags) : var.tags

  # Module-level defaults with per-instance override
  tunnel_detection_time = each.value.tunnel_detection_time != null ? each.value.tunnel_detection_time : var.tunnel_detection_time
  insane_mode           = each.value.insane_mode != null ? each.value.insane_mode : var.insane_mode
  subnet_ipv6_cidr      = each.value.subnet_ipv6_cidr

  # Route
  filtered_spoke_vpc_routes      = each.value.filtered_spoke_vpc_routes
  enable_monitor_gateway_subnets = each.value.enable_monitor_gateway_subnets
  monitor_exclude_list           = each.value.monitor_exclude_list

  # Spot
  enable_spot_instance = each.value.enable_spot_instance
  spot_price           = each.value.spot_price
  delete_spot          = each.value.delete_spot

  # BGP over LAN
  enable_bgp_over_lan      = each.value.enable_bgp_over_lan
  bgp_lan_interfaces_count = each.value.bgp_lan_interfaces_count

  # Encryption (module-level defaults with per-instance override)
  enable_encrypt_volume = each.value.enable_encrypt_volume != null ? each.value.enable_encrypt_volume : var.enable_encrypt_volume
  customer_managed_keys = each.value.customer_managed_keys != null ? each.value.customer_managed_keys : var.customer_managed_keys

  # AWS-specific
  insane_mode_az       = each.value.insane_mode_az
  insertion_gateway    = each.value.insertion_gateway
  insertion_gateway_az = each.value.insertion_gateway_az
  rx_queue_size        = each.value.rx_queue_size != null ? each.value.rx_queue_size : var.rx_queue_size

  # Azure-specific
  azure_eip_name_resource_group = each.value.azure_eip_name_resource_group

  # OCI-specific
  availability_domain = each.value.availability_domain
  fault_domain        = each.value.fault_domain

  # Private network
  private_subnet_egress_target = each.value.private_subnet_egress_target

  # Edge: interfaces
  dynamic "interfaces" {
    for_each = each.value.interfaces != null ? each.value.interfaces : []
    content {
      logical_ifname = interfaces.value.logical_ifname
      type           = interfaces.value.type
      ip_address     = interfaces.value.ip_address
      gateway_ip     = interfaces.value.gateway_ip
      public_ip      = interfaces.value.public_ip
      dhcp           = interfaces.value.dhcp
    }
  }

  # Edge: interface_mapping
  dynamic "interface_mapping" {
    for_each = each.value.interface_mapping != null ? each.value.interface_mapping : []
    content {
      name  = interface_mapping.value.name
      type  = interface_mapping.value.type
      index = interface_mapping.value.index
    }
  }

  # Edge: other
  ztp_file_download_path           = each.value.ztp_file_download_path
  ztp_file_type                    = each.value.ztp_file_type
  device_id                        = each.value.device_id
  management_egress_ip_prefix_list = each.value.management_egress_ip_prefix_list
}

###############################################################################
# Transit Attachment (primary)
###############################################################################
resource "aviatrix_spoke_transit_attachment" "default" {
  count = var.attached && length(var.transit_gw) > 0 ? 1 : 0

  spoke_gw_name           = local.first_instance_name
  transit_gw_name         = var.transit_gw
  route_tables            = var.transit_gw_route_tables
  enable_max_performance  = var.enable_max_performance
  spoke_prepend_as_path   = var.spoke_prepend_as_path
  transit_prepend_as_path = var.transit_prepend_as_path
  tunnel_count            = var.tunnel_count

  depends_on = [aviatrix_spoke_instance.this]
}

###############################################################################
# Transit Attachment (egress)
###############################################################################
resource "aviatrix_spoke_transit_attachment" "transit_gw_egress" {
  count = length(var.transit_gw_egress) > 0 && var.attached_gw_egress ? 1 : 0

  spoke_gw_name           = local.first_instance_name
  transit_gw_name         = var.transit_gw_egress
  route_tables            = var.transit_gw_egress_route_tables
  enable_max_performance  = var.enable_max_performance
  spoke_prepend_as_path   = var.spoke_prepend_as_path
  transit_prepend_as_path = var.transit_prepend_as_path
  tunnel_count            = var.egress_tunnel_count

  depends_on = [aviatrix_spoke_instance.this]
}

###############################################################################
# Segmentation Network Domain Association
###############################################################################
resource "aviatrix_segmentation_network_domain_association" "default" {
  count = length(var.network_domain) > 0 && var.attached ? 1 : 0

  transit_gateway_name = var.transit_gw
  network_domain_name  = var.network_domain
  attachment_name      = local.first_instance_name

  depends_on = [aviatrix_spoke_transit_attachment.default]

  lifecycle {
    replace_triggered_by = [
      aviatrix_spoke_transit_attachment.default,
    ]
  }
}

###############################################################################
# Transit FireNet Inspection Policy
###############################################################################
resource "aviatrix_transit_firenet_policy" "default" {
  count = var.inspection && var.attached ? 1 : 0

  transit_firenet_gateway_name = var.transit_gw
  inspected_resource_name      = "SPOKE:${local.first_instance_name}"

  depends_on = [aviatrix_spoke_transit_attachment.default]
}

# terraform-aviatrix-mc-spoke-group release notes

## 9.0.0
### Initial release
Initial release of the mc-spoke-group module, built on the `aviatrix_spoke_group` and `aviatrix_spoke_instance` resources introduced in controller 9.0.

This module replaces the primary+HA gateway pair model used by `mc-spoke` with a group model that allows horizontal scaling by adding instances to the group independently of the group-level policy.

### Features
- Multi-cloud support (AWS, Azure, GCP, OCI, Alibaba)
- Flexible instance map — deploy one or many gateway instances per group
- Per-instance overrides for size, subnet, zone, tags, HPE, and more
- Module-level defaults for common settings (tags, insane_mode, tunnel_detection_time, etc.)
- Transit attachment with optional egress transit support
- Network domain and inspection policy support
- Private network deployment (AWS, Azure) — gateways without public IPs
- BGP, BGP over LAN, learned CIDRs approval
- Active-standby mode
- Edge spoke support (EDGESPOKE gateway type)

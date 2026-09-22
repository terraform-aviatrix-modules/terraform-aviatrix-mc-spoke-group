output "vpc" {
  description = "The created VPC object. Null when use_existing_vpc is true."
  value       = var.use_existing_vpc ? null : aviatrix_vpc.default[0]
}

output "spoke_group" {
  description = "The spoke group object."
  value       = aviatrix_spoke_group.default
}

output "spoke_instances" {
  description = "Map of all spoke instance objects, keyed by gateway name."
  value       = aviatrix_spoke_instance.this
}

output "first_instance_name" {
  description = "Name of the first spoke instance (used for attachment references)."
  value       = local.first_instance_name
}

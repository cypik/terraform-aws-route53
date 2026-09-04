output "id" {
  value       = module.records.zone_id
  description = "The ID of the Hostzone."
}

output "tags" {
  value       = module.records.tags
  description = "A mapping of tags to assign to the resource."
}

output "record_names" {
  value       = module.records.record_names
  description = "Fully qualified domain names (FQDNs) of the created Route53 records."
}

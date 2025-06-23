variable "zone_id" {
  type        = string
  description = "(Required) The Hosted Zone ID"
}


variable "records_map" {
  description = "(Optional) Map of Route53 records to create"
  type = map(object({
    name   = string
    type   = string
    ttl    = optional(number)
    values = optional(string)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }))
    set_identifier  = optional(string)
    health_check_id = optional(string)
    allow_overwrite = optional(bool, false)
  }))
  default = {}
}

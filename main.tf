resource "aws_route53_record" "records" {
  for_each = {
    for k, v in var.records_map : k => v
    if v.alias == null
  }

  zone_id         = var.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = each.value.ttl
  records         = split(",", each.value.values)
  set_identifier  = lookup(each.value, "set_identifier", null)
  health_check_id = lookup(each.value, "health_check_id", null)
  allow_overwrite = lookup(each.value, "allow_overwrite", false)
}

resource "aws_route53_record" "alias_records" {
  for_each = {
    for k, v in var.records_map : k => v
    if v.alias != null
  }

  zone_id         = var.zone_id
  name            = each.value.name
  type            = each.value.type
  set_identifier  = lookup(each.value, "set_identifier", null)
  health_check_id = lookup(each.value, "health_check_id", null)
  allow_overwrite = lookup(each.value, "allow_overwrite", false)

  alias {
    name                   = each.value.alias.name
    zone_id                = each.value.alias.zone_id
    evaluate_target_health = each.value.alias.evaluate_target_health
  }
}

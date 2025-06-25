provider "aws" {
  region = "eu-west-1"
}

locals {
  zone_id = "Z0711xxxxxxNM0M4C8IJ" # Route53 Zone ID
}

data "aws_lb" "lb_1" {
  name = "test-lb"
}

data "aws_lb" "lb_2" {
  name = "test-lb-2"
}

module "route53" {
  source                    = "../../"
  name                      = "route53"
  environment               = "test"
  label_order               = ["environment", "name"]
  public_hostedzone_enabled = false
  record_enabled            = true

  zone_id     = local.zone_id
  domain_name = "cypik.com"

  records = [
    {
      name = "test"
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.10",
      ]
    },
    {
      name           = "geo"
      type           = "CNAME"
      ttl            = 5
      records        = ["cypik.com"]
      set_identifier = "europe"
      geolocation_routing_policy = {
        continent = "EU"
      }
    },
    {
      name = "alias-1"
      type = "A"
      alias = {
        name    = "CHANGEME001" # name of the attached service.
        zone_id = local.zone_id
      }
    },
    {
      name           = "weighted-policy-test-2"
      type           = "A"
      set_identifier = "test-1"
      alias = {
        name    = data.aws_lb.lb_1
        zone_id = data.aws_lb.lb_1.zone_id
      }
      weighted_routing_policy = {
        weight = 50
      }
    },
    {
      name           = "weighted"
      type           = "A"
      set_identifier = "test-2"
      alias = {
        name    = data.aws_lb.lb_2.dns_name
        zone_id = data.aws_lb.lb_2.zone_id
      }
      weighted_routing_policy = {
        weight = 50
      }
    }
  ]
}
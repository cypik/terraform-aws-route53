provider "aws" {
  region = "eu-west-1"
}

module "route53-record" {
  source  = "./../../"
  zone_id = "Z1xxxxSSBKXLC1"
  name    = "www"
  type    = "A"
  alias = {
    name                   = "d130easdflja734js.cloudfront.net"
    zone_id                = "ZxxxATA1ER4"
    evaluate_target_health = false
  }
}

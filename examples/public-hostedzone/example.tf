provider "aws" {
  region = "eu-west-1"
}

module "route53" {
  source                    = "../../"
  name                      = "route53"
  environment               = "test"
  label_order               = ["environment", "name"]
  public_hostedzone_enabled = true
  record_enabled            = true

  domain_name = "cypik.com"

  records = [
    {
      name    = "www"
      type    = "CNAME"
      ttl     = 300
      records = ["ns-896.awsdns-48.net"]
    },
    {
      name    = "admin"
      type    = "CNAME"
      ttl     = 3600
      records = ["ns-896.awsdns-48.net"]
    },
  ]
}

provider "aws" {
  region = "eu-west-1"
}

module "route53" {
  source                     = "../../"
  name                       = "route53"
  environment                = "test"
  label_order                = ["environment", "name"]
  private_hostedzone_enabled = true
  record_enabled             = true

  domain_name = "cypik.com"
  vpc_id      = "vpc-00e9aea7c2eec3a0a" # VPC ID to associate

  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = ["10.0.0.27"]
    },
    {
      name    = "admin"
      type    = "CNAME"
      ttl     = 3600
      records = ["mydomain.com"]
    },
  ]
}

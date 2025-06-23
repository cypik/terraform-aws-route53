provider "aws" {
  region = "us-east-2"
}

module "route53-alias-records" {
  source  = "./../../"
  zone_id = "Z1xxxxSSBKXLC1"

  records_map = {
    alias_record_1 = {
      name = "test"
      type = "A"
      alias = {
        name                   = "satishdesign.com"
        zone_id                = "Z2FDTNDATAQYW2"
        evaluate_target_health = false
      }
    }

    alias_record_2 = {
      name = "cdn"
      type = "A"
      alias = {
        name                   = "satishdesign.com"
        zone_id                = "Z2FDTNDATAQYW2"
        evaluate_target_health = true
      }
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "route53-simple-records" {
  source  = "./../../"
  zone_id = "Z1xxxxKXLC1"

  records_map = {
    simple_record_1 = {
      name   = "web"
      type   = "A"
      ttl    = 3600
      values = "10.0.0.27"
    }

    simple_record_2 = {
      name   = "app"
      type   = "A"
      ttl    = 300
      values = "10.0.0.10,10.0.0.11"
    }
  }
}

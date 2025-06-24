# Terraform-aws-route53-record

# Terraform AWS Cloud-Route53-Record Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#Examples)
- [Author](#Author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform module creates an AWS Route53-Record along with additional configuration options.
## Usage
To use this module, you can include it in your Terraform configuration. Here's an example of how to use it:

## Examples

## Example: private-hostedzone

```hcl
module "route53" {
  source          = "cypik/route53-record /aws"
  version         = "1.0.0"
  name            = "route53"
  environment     = "test"
  label_order     = ["environment", "name"]
  private_hostedzone_enabled = true
  record_enabled  = true

  domain_name = "cypik.com"
  vpc_id      = "vpc-xxxxxxxxxxxx" # VPC ID to associate

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
```

## Example: public-hostedzone

```hcl
module "route53" {
  source         = "cypik/route53-record /aws"
  version        = "1.0.0"
  name           = "route53"
  environment    = "test"
  label_order    = ["environment", "name"]
  public_hostedzone_enabled = true
  record_enabled = true

  domain_name = "cypik.com"

  records = [
    {
      name = "www"
      type = "A"
      alias = {
        name    = "d130easdflja734js.cloudfront.net" # name/DNS of attached cloudfront.
        zone_id = "Z2XXXXHXTXXXX4"                   # A valid zone ID of cloudfront you are trying to create alias of.
      }
    },
    {
      name    = "admin"
      type    = "CNAME"
      ttl     = 3600
      records = ["d130easdflja734js.cloudfront.net"]
    },
  ]
}
```

## Example: records

```hcl
module "route53" {
  source         = "cypik/route53-record /aws"
  version        = "1.0.0"
  name           = "route53"
  environment    = "test"
  label_order    = ["environment", "name"]
  public_hostedzone_enabled = false
  record_enabled = true

  zone_id     = local.zone_id
  domain_name = "cypik.com"

  records = [
    {
      name = ""
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
```

## Example
For detailed examples on how to use this module, please refer to the [examples](https://github.com/cypik/terraform-aws-route53-record/tree/master/examples) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-aws-route53-record/blob/master/LICENSE) file for details.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.82.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.alias_records](https://registry.terraform.io/providers/hashicorp/aws/5.82.2/docs/resources/route53_record) | resource |
| [aws_route53_record.records](https://registry.terraform.io/providers/hashicorp/aws/5.82.2/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | An alias block. Conflicts with ttl & records. Alias record documented below. | `map(any)` | `{}` | no |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record. false by default. This configuration is not recommended for most environments. | `bool` | `false` | no |
| <a name="input_health_check_id"></a> [health\_check\_id](#input\_health\_check\_id) | The health check the record should be associated with. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the record. | `string` | `""` | no |
| <a name="input_record_enabled"></a> [record\_enabled](#input\_record\_enabled) | Whether to create Route53 record set. | `bool` | `true` | no |
| <a name="input_records_map"></a> [records\_map](#input\_records\_map) | (Optional) Map of Route53 records to create | <pre>map(object({<br>    name   = string<br>    type   = string<br>    ttl    = optional(number)<br>    values = optional(string)<br>    alias = optional(object({<br>      name                   = string<br>      zone_id                = string<br>      evaluate_target_health = bool<br>    }))<br>    set_identifier  = optional(string)<br>    health_check_id = optional(string)<br>    allow_overwrite = optional(bool, false)<br>  }))</pre> | `{}` | no |
| <a name="input_set_identifier"></a> [set\_identifier](#input\_set\_identifier) | Unique identifier to differentiate records with routing policies from one another. Required if using failover, geolocation, latency, or weighted routing policies documented below. | `string` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | (Required for non-alias records) The TTL of the record. | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT. | `string` | `""` | no |
| <a name="input_values"></a> [values](#input\_values) | (Required for non-alias records) A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add "" inside the Terraform configuration string (e.g. "first255characters""morecharacters"). | `string` | `""` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | (Required) The Hosted Zone ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
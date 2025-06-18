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

## Example: set-with-alias

```hcl
module "route53-record" {
  source  = "cypik/route53-record/aws"
  version = "1.0.0"
  zone_id = "ZxxxxSSBKXLC1"
  name    = "www"
  type    = "A"
  alias = {
    name                   = "d130easdflja734js.cloudfront.net"
    zone_id                = "ZxxxxRFHATA1ER4"
    evaluate_target_health = false
  }
}
```
## Example: mysql-complete
```hcl
module "route53-record" {
  source  = "cypik/route53-record/aws"
  version = "1.0.0"
  zone_id = "xxxxXJD7SxxSBKXLC1"
  name    = "www"
  type    = "A"
  ttl     = "3600"
  values  = "10.0.0.27"
}
```

## Example
For detailed examples on how to use this module, please refer to the [example](https://github.com/cypik/terraform-aws-route53-record/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-aws-route53-record/blob/master/LICENSE) file for details.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.0.0-beta3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0-beta3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/6.0.0-beta3/docs/resources/route53_record) | resource |
| [aws_route53_record.default](https://registry.terraform.io/providers/hashicorp/aws/6.0.0-beta3/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | An alias block. Conflicts with ttl & records. Alias record documented below. | `map(any)` | `{}` | no |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record. false by default. This configuration is not recommended for most environments. | `bool` | `false` | no |
| <a name="input_health_check_id"></a> [health\_check\_id](#input\_health\_check\_id) | The health check the record should be associated with. | `string` | `""` | no |
| <a name="input_multivalue_answer_routing_policy"></a> [multivalue\_answer\_routing\_policy](#input\_multivalue\_answer\_routing\_policy) | Set to true to indicate a multivalue answer routing policy. Conflicts with any other routing policy. | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the record. | `string` | `""` | no |
| <a name="input_record_enabled"></a> [record\_enabled](#input\_record\_enabled) | Whether to create Route53 record set. | `bool` | `true` | no |
| <a name="input_set_identifier"></a> [set\_identifier](#input\_set\_identifier) | Unique identifier to differentiate records with routing policies from one another. Required if using failover, geolocation, latency, or weighted routing policies documented below. | `string` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | (Required for non-alias records) The TTL of the record. | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT. | `string` | `""` | no |
| <a name="input_values"></a> [values](#input\_values) | (Required for non-alias records) A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add "" inside the Terraform configuration string (e.g. "first255characters""morecharacters"). | `string` | `""` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Zone ID. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
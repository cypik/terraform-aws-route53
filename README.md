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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.82.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.82.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/aws | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. Defaults to 'Managed by Terraform'. | `string` | `""` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc as delegation sets can only be used for public zones. | `string` | `""` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | This is the name of the resource. | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to control the Route53 and related resources creation. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone. | `bool` | `true` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com'. | `string` | `"info@cypik.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_private_hostedzone_enabled"></a> [private\_hostedzone\_enabled](#input\_private\_hostedzone\_enabled) | Whether to create private Route53 zone. | `bool` | `false` | no |
| <a name="input_public_hostedzone_enabled"></a> [public\_hostedzone\_enabled](#input\_public\_hostedzone\_enabled) | Whether to create public Route53 zone. | `bool` | `false` | no |
| <a name="input_record_enabled"></a> [record\_enabled](#input\_record\_enabled) | Whether to create Route53 record set. | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | List of objects of DNS records | `any` | `[]` | no |
| <a name="input_records_jsonencoded"></a> [records\_jsonencoded](#input\_records\_jsonencoded) | List of map of DNS records (stored as jsonencoded string, for terragrunt) | `string` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-aws-route53"` | no |
| <a name="input_secondary_vpc_id"></a> [secondary\_vpc\_id](#input\_secondary\_vpc\_id) | The VPC to associate with the private hosted zone. | `string` | `""` | no |
| <a name="input_vpc_association_enabled"></a> [vpc\_association\_enabled](#input\_vpc\_association\_enabled) | Whether to create Route53 vpc association. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. | `string` | `""` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 Zone ID. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_names"></a> [record\_names](#output\_record\_names) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | A mapping of tags to assign to the resource. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. This can be referenced by zone records. |
<!-- END_TF_DOCS -->
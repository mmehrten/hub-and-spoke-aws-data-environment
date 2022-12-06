Attach a VPC to a transit gateway.

Assumes that you already have a route table and tgw, and that your route table is associated with
your current subnets.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 4.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | = 4.44.0 |
| <a name="provider_aws.root"></a> [aws.root](#provider\_aws.root) | = 4.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_peering_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_peering_attachment) | resource |
| [aws_ec2_transit_gateway_peering_attachment_accepter.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_peering_attachment_accepter) | resource |
| [aws_ec2_transit_gateway_route.peer-internal](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.peer-root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.root-peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_association.peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_association.root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.peer-root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route) | resource |
| [aws_route.root-peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route) | resource |
| [aws_route53_vpc_association_authorization.peer-dns-root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_vpc_association_authorization.root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_vpc_association_authorization.root-dns-peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_zone.peer-dns](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone_association.peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_zone_association) | resource |
| [aws_route53_zone_association.peer-root-dns](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_zone_association) | resource |
| [aws_route53_zone_association.root-peer-dns](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_zone_association) | resource |
| [aws_ec2_transit_gateway_peering_attachment.accepter](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/ec2_transit_gateway_peering_attachment) | data source |
| [aws_ec2_transit_gateway_route_table.root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/ec2_transit_gateway_route_table) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.root-dns](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/route53_zone) | data source |
| [aws_route_table.peer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/route_table) | data source |
| [aws_route_table.root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/route_table) | data source |
| [aws_vpc.root](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_cidr-block"></a> [cidr-block](#input\_cidr-block) | The CIDR of the spoke VPC | `string` | n/a | yes |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_root-account-id"></a> [root-account-id](#input\_root-account-id) | The ID of the transit gateway to attach to. | `string` | n/a | yes |
| <a name="input_root-region"></a> [root-region](#input\_root-region) | The ID of the transit gateway to attach to. | `string` | n/a | yes |
| <a name="input_subnet-ids"></a> [subnet-ids](#input\_subnet-ids) | The subnet IDs in the main VPC to attach the TGW to. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_transit-gateway-id"></a> [transit-gateway-id](#input\_transit-gateway-id) | The ID of the transit gateway to attach to. | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | The ID of the VPC to attach the TGW to, should be the root VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route-53-zone"></a> [route-53-zone](#output\_route-53-zone) | n/a |

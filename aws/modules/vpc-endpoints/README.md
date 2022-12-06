  Create a VPC interface endpoints for the configured services, and a gateway endpoint for S3.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 4.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | = 4.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.org](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/route53_zone) | resource |
| [aws_security_group.endpoint-security-group](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.access](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3-gateway](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/vpc_endpoint) | resource |
| [aws_subnet.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | A list of the services to create interface endpoints for. | `list(string)` | <pre>[<br>  "airflow.api",<br>  "airflow.env",<br>  "airflow.ops",<br>  "ecr.api",<br>  "ecr.dkr",<br>  "kms",<br>  "logs",<br>  "monitoring",<br>  "sqs",<br>  "elasticmapreduce",<br>  "ecs",<br>  "rds",<br>  "secretsmanager",<br>  "ssm",<br>  "ec2messages",<br>  "ssmmessages"<br>]</pre> | no |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_route-table-ids"></a> [route-table-ids](#input\_route-table-ids) | The route table IDs to associate the gateways with. | `list(string)` | n/a | yes |
| <a name="input_subnet-ids"></a> [subnet-ids](#input\_subnet-ids) | A map of the subnet IDs to associate the gateways with. | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | The VPC ID to create the gateways in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_outputs"></a> [outputs](#output\_outputs) | n/a |

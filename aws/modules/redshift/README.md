Create a Redshift culster.

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
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/kms_key) | resource |
| [aws_redshift_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/redshift_cluster) | resource |
| [aws_redshift_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/redshift_subnet_group) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/security_group) | resource |
| [aws_subnets.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_database-name"></a> [database-name](#input\_database-name) | The Redshift database name | `string` | `"dev"` | no |
| <a name="input_master-password"></a> [master-password](#input\_master-password) | The cluster admin user password | `string` | n/a | yes |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | The VPC to create the cluster in | `string` | n/a | yes |

## Outputs

No outputs.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 4.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | = 4.44.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_users"></a> [users](#module\_users) | ../console-user | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lakeformation_permissions.db](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.table](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_quicksight_group.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/quicksight_group) | resource |
| [aws_quicksight_group_membership.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/quicksight_group_membership) | resource |
| [aws_quicksight_user.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/quicksight_user) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_pgp-key"></a> [pgp-key](#input\_pgp-key) | PGP key to use for user password encryption | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | The VPC to run Quicksight in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_users"></a> [users](#output\_users) | n/a |

Create a private S3 bucket with a dedicated KMS key.

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
| [aws_kms_key.encrypt-main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.main-expire](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.main-block](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.main-encryption](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.main-versioning](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_bucket-name"></a> [bucket-name](#input\_bucket-name) | The name of the bucket to provision. | `string` | n/a | yes |
| <a name="input_expiration-days"></a> [expiration-days](#input\_expiration-days) | Number of days to wait before cleaning up objects. | `number` | `0` | no |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Whether or not to enable bucket versioning. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_outputs"></a> [outputs](#output\_outputs) | n/a |

Create a Glue catalog and database.

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
| [aws_glue_catalog_database.source-db](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/glue_catalog_database) | resource |
| [aws_glue_connection.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/glue_connection) | resource |
| [aws_glue_connection.redshift-serverless](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/glue_connection) | resource |
| [aws_glue_crawler.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/glue_crawler) | resource |
| [aws_glue_crawler.redshift](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/glue_crawler) | resource |
| [aws_glue_resource_policy.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/glue_resource_policy) | resource |
| [aws_iam_role.client](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role.client-super](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role.consumer](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role.etl](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role.runtime](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_role) | resource |
| [aws_lakeformation_data_lake_settings.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_data_lake_settings) | resource |
| [aws_lakeformation_lf_tag.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_lf_tag) | resource |
| [aws_lakeformation_permissions.admin-tag-share](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.client](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.client-data-source](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.client-tag-share](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.consumer-db](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.consumer-tables](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.etl-data-source](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.etl-dev](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.etl-tag-share](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.tag-table-shares](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.tag-tag-shares](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_resource.buckets](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_resource) | resource |
| [aws_lakeformation_resource_lf_tags.source-db](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/lakeformation_resource_lf_tags) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/subnet) | data source |
| [aws_subnets.main](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_catalog-account-id"></a> [catalog-account-id](#input\_catalog-account-id) | The ID of the transit gateway to attach to. | `string` | n/a | yes |
| <a name="input_crawlers"></a> [crawlers](#input\_crawlers) | A map of key-value pairs for the crawlers to create. | `map(any)` | n/a | yes |
| <a name="input_databases"></a> [databases](#input\_databases) | A map of key-value pairs for the databases to create and LF tags to apply. | `map(any)` | n/a | yes |
| <a name="input_lf-tag-shares"></a> [lf-tag-shares](#input\_lf-tag-shares) | Mapping of principals to share data with by LF tag | `any` | n/a | yes |
| <a name="input_lf-tags"></a> [lf-tags](#input\_lf-tags) | A map of key-value pairs for LF tags in Lake Formation | `map(any)` | n/a | yes |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_read-bucket-arns"></a> [read-bucket-arns](#input\_read-bucket-arns) | The ARNs for buckets with read access. | `list(string)` | n/a | yes |
| <a name="input_redshift-jdbc-url"></a> [redshift-jdbc-url](#input\_redshift-jdbc-url) | The JDBC endpoint URL to use for a Redshift Serverless connection | `string` | n/a | yes |
| <a name="input_redshift-password"></a> [redshift-password](#input\_redshift-password) | The password to use for a Redshift Serverless connection | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | The VPC to run Glue in. | `string` | n/a | yes |
| <a name="input_write-bucket-arns"></a> [write-bucket-arns](#input\_write-bucket-arns) | The ARNs for buckets with write access. | `list(string)` | n/a | yes |

## Outputs

No outputs.

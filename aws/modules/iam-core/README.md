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
| [aws_iam_group.config-groups](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.config-groups-policies](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.policies](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_policy) | resource |
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.users-groups](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_login_profile.users-profiles](https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/iam_user_login_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account-id"></a> [account-id](#input\_account-id) | The account to create resources in. | `string` | n/a | yes |
| <a name="input_app-name"></a> [app-name](#input\_app-name) | The longhand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_app-shorthand-name"></a> [app-shorthand-name](#input\_app-shorthand-name) | The shorthand name of the app being provisioned. | `string` | n/a | yes |
| <a name="input_base-name"></a> [base-name](#input\_base-name) | The base name to create new resources with (e.g. {app\_shorthand}.{region}). | `string` | n/a | yes |
| <a name="input_builtin_policies"></a> [builtin\_policies](#input\_builtin\_policies) | A map of builtin policy names to the ARN of the policy. | `map(string, object({ arn = string }))` | <pre>{<br>  "AWSGlueConsoleFullAccess": {<br>    "arn": "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"<br>  },<br>  "AWSGlueSchemaRegistryFullAccess": {<br>    "arn": "arn:aws:iam::aws:policy/AWSGlueSchemaRegistryFullAccess"<br>  },<br>  "AWSLambda_FullAccess": {<br>    "arn": "arn:aws:iam::aws:policy/AWSLambda_FullAccess"<br>  },<br>  "AdministratorAccess": {<br>    "arn": "arn:aws:iam::aws:policy/AdministratorAccess"<br>  },<br>  "AmazonS3FullAccess": {<br>    "arn": "arn:aws:iam::aws:policy/AmazonS3FullAccess"<br>  },<br>  "AmazonSageMakerFullAccess": {<br>    "arn": "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"<br>  },<br>  "IAMFullAccess": {<br>    "arn": "arn:aws:iam::aws:policy/IAMFullAccess"<br>  }<br>}</pre> | no |
| <a name="input_groups"></a> [groups](#input\_groups) | A map of group name to the policy attachments for that group. | `map(string, object({ policies = list(string) }))` | <pre>{<br>  "AWSAdmins": {<br>    "policies": [<br>      "AdministratorAccess"<br>    ]<br>  },<br>  "AirflowUser": {<br>    "policies": [<br>      "AirflowUser"<br>    ]<br>  },<br>  "AirflowViewer": {<br>    "policies": [<br>      "AirflowViewer"<br>    ]<br>  },<br>  "BaseAWSUser": {<br>    "policies": [<br>      "AirflowViewer",<br>      "AthenaReadOnly",<br>      "CodeCommitDenyPushToMain",<br>      "CodeCommitDeveloper",<br>      "ECSReadOnly",<br>      "EMRReadOnly",<br>      "GlueReadOnly",<br>      "LambdaReadOnly",<br>      "S3ScratchBucketUser"<br>    ]<br>  },<br>  "Developer": {<br>    "policies": [<br>      "CodeBuildDeveloper",<br>      "CodeCommitDenyPushToMain",<br>      "CodeCommitDeveloper",<br>      "ECSDeveloper",<br>      "EMRDeveloper",<br>      "SecretManagerReader",<br>      "SystemManagerReader",<br>      "AmazonS3FullAccess",<br>      "AWSGlueConsoleFullAccess",<br>      "AWSGlueSchemaRegistryFullAccess",<br>      "AWSLambda_FullAccess"<br>    ]<br>  },<br>  "Internal": {<br>    "policies": [<br>      "CodeCommitDenyPushToMain"<br>    ]<br>  },<br>  "SageMakerAdmin": {<br>    "policies": [<br>      "AmazonSageMakerFullAccess"<br>    ]<br>  },<br>  "TerraformUser": {<br>    "policies": [<br>      "IAMFullAccess"<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_org-shorthand-name"></a> [org-shorthand-name](#input\_org-shorthand-name) | The organization's descriptor, shorthand (e.g. Any Company -> ac) | `string` | `"ac"` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The partition to create resources in. | `string` | `"aws"` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | A map of policy name to the description for the policy. The policy JSON must be in a file in the iam\_policies folder. | `map(string, object({ description = string }))` | <pre>{<br>  "AirflowAdmin": {<br>    "description": null<br>  },<br>  "AirflowUser": {<br>    "description": null<br>  },<br>  "AirflowViewer": {<br>    "description": "Allow read only access for Airflow server."<br>  },<br>  "AthenaReadOnly": {<br>    "description": "Allow read only access for Athena resources."<br>  },<br>  "CodeBuildDeveloper": {<br>    "description": "Policies to allow access to CodeBuild and CodePipelines."<br>  },<br>  "CodeCommitDenyPushToMain": {<br>    "description": "Deny direct push to main branches in CodeCommit."<br>  },<br>  "CodeCommitDeveloper": {<br>    "description": "Basic CodeCommit developer access for existing repositories."<br>  },<br>  "ECSDeveloper": {<br>    "description": null<br>  },<br>  "ECSReadOnly": {<br>    "description": "Allow read only access for ECS resources."<br>  },<br>  "EMRDeveloper": {<br>    "description": "Permissions to create and run EMR jobs and clusters."<br>  },<br>  "EMRReadOnly": {<br>    "description": "Allow read only access for EMR resources."<br>  },<br>  "GlueReadOnly": {<br>    "description": "Allow read only access for Glue resources."<br>  },<br>  "LambdaReadOnly": {<br>    "description": "Allow read only access for Lambda resources."<br>  },<br>  "S3ScratchBucketUser": {<br>    "description": "Permissions to read and write to single scratch S3 bucket."<br>  },<br>  "SecretManagerReader": {<br>    "description": "Allow read access to secret values."<br>  },<br>  "SystemManagerReader": {<br>    "description": "Allow read access to system manger values."<br>  }<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | n/a | yes |
| <a name="input_terraform-role"></a> [terraform-role](#input\_terraform-role) | The role for Terraform to use, which dictates the account resources are created in. | `string` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | A map of user name to the group attachments for that user. | `map(string, object({ groups = list(string) }))` | <pre>{<br>  "example-user": {<br>    "groups": [<br>      "AWSAdmins"<br>    ]<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_outputs"></a> [outputs](#output\_outputs) | A map of the users and their ARNs that are provisioned based on the input variables. |

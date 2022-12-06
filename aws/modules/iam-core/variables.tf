
variable "groups" {
  default = {
    AirflowUser    = { policies = ["AirflowUser"] }
    AirflowViewer  = { policies = ["AirflowViewer"] }
    AWSAdmins      = { policies = ["AdministratorAccess"] }
    SageMakerAdmin = { policies = ["AmazonSageMakerFullAccess"] }
    Developer = {
      policies = [
        "CodeBuildDeveloper",
        "CodeCommitDenyPushToMain",
        "CodeCommitDeveloper",
        "ECSDeveloper",
        "EMRDeveloper",
        "SecretManagerReader",
        "SystemManagerReader",
        "AmazonS3FullAccess",
        "AWSGlueConsoleFullAccess",
        "AWSGlueSchemaRegistryFullAccess",
        "AWSLambda_FullAccess",
      ]
    }
    Internal      = { policies = ["CodeCommitDenyPushToMain"] }
    TerraformUser = { policies = ["IAMFullAccess"] }
    BaseAWSUser = {
      policies = [
        "AirflowViewer",
        "AthenaReadOnly",
        "CodeCommitDenyPushToMain",
        "CodeCommitDeveloper",
        "ECSReadOnly",
        "EMRReadOnly",
        "GlueReadOnly",
        "LambdaReadOnly",
        "S3ScratchBucketUser",
      ]
    }
  }

  type        = map(string, object({ policies = list(string) }))
  description = "A map of group name to the policy attachments for that group."
}
variable "users" {
  default = {
    example-user = { groups = ["AWSAdmins"] }
  }
  type        = map(string, object({ groups = list(string) }))
  description = "A map of user name to the group attachments for that user."
}
variable "builtin_policies" {
  default = {
    AWSGlueConsoleFullAccess        = { arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess" }
    AWSGlueSchemaRegistryFullAccess = { arn = "arn:aws:iam::aws:policy/AWSGlueSchemaRegistryFullAccess" }
    AWSLambda_FullAccess            = { arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess" }
    AdministratorAccess             = { arn = "arn:aws:iam::aws:policy/AdministratorAccess" }
    AmazonS3FullAccess              = { arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" }
    AmazonSageMakerFullAccess       = { arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess" }
    IAMFullAccess                   = { arn = "arn:aws:iam::aws:policy/IAMFullAccess" }
  }
  type        = map(string, object({ arn = string }))
  description = "A map of builtin policy names to the ARN of the policy."
}
variable "policies" {
  default = {
    AirflowAdmin             = { description = null }
    AirflowViewer            = { description = "Allow read only access for Airflow server." }
    AirflowUser              = { description = null }
    AthenaReadOnly           = { description = "Allow read only access for Athena resources." }
    CodeBuildDeveloper       = { description = "Policies to allow access to CodeBuild and CodePipelines." }
    CodeCommitDenyPushToMain = { description = "Deny direct push to main branches in CodeCommit." }
    CodeCommitDeveloper      = { description = "Basic CodeCommit developer access for existing repositories." }
    ECSDeveloper             = { description = null }
    EMRDeveloper             = { description = "Permissions to create and run EMR jobs and clusters." }
    ECSReadOnly              = { description = "Allow read only access for ECS resources." }
    EMRReadOnly              = { description = "Allow read only access for EMR resources." }
    GlueReadOnly             = { description = "Allow read only access for Glue resources." }
    LambdaReadOnly           = { description = "Allow read only access for Lambda resources." }
    S3ScratchBucketUser      = { description = "Permissions to read and write to single scratch S3 bucket." }
    SecretManagerReader      = { description = "Allow read access to secret values." }
    SystemManagerReader      = { description = "Allow read access to system manger values." }
  }
  type        = map(string, object({ description = string }))
  description = "A map of policy name to the description for the policy. The policy JSON must be in a file in the iam_policies folder."
}
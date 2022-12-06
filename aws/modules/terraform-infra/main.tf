/*
* The required infrastructure to run Terraform in an AWS account.
*/
module "iam" {
  region             = var.region
  partition          = var.partition
  account-id         = var.account-id
  app-shorthand-name = var.app-shorthand-name
  app-name           = var.app-name
  terraform-role     = var.terraform-role
  tags               = var.tags
  base-name          = var.base-name

  runner-role-arns = var.runner-role-arns
  source           = "../terraform-role"
}

module "s3" {
  region             = var.region
  partition          = var.partition
  account-id         = var.account-id
  app-shorthand-name = var.app-shorthand-name
  app-name           = var.app-name
  terraform-role     = var.terraform-role
  tags               = var.tags
  base-name          = var.base-name

  bucket-name = "${var.base-name}.s3.terraform"
  versioning  = true
  source      = "../s3"
}

module "dynamodb" {
  region             = var.region
  partition          = var.partition
  account-id         = var.account-id
  app-shorthand-name = var.app-shorthand-name
  app-name           = var.app-name
  terraform-role     = var.terraform-role
  tags               = var.tags
  base-name          = var.base-name

  table-name = "${var.base-name}.dynamodb.terraform"
  hash-key   = "LockID"
  source     = "../dynamodb"
}
resource "aws_organizations_account" "main" {
  name  = var.account-name
  email = var.account-owner
}

provider "aws" {
  region = var.region
  assume_role { role_arn = "arn:aws:iam::${aws_organizations_account.main.id}:role/OrganizationAccountAccessRole" }
  default_tags { tags = var.tags }
  alias = "child"
}

module "iam" {
  providers          = { aws = aws.child }
  region             = var.region
  account-id         = aws_organizations_account.main.id
  app-shorthand-name = var.app-shorthand-name
  app-name           = var.app-name
  # Use the child account admin role to provision the Terraform role
  terraform-role = "arn:aws:iam::${aws_organizations_account.main.id}:role/OrganizationAccountAccessRole"
  tags           = var.tags
  base-name      = var.base-name

  # Allow the root account Terraform role to assume the child account Terraform role
  runner-role-arns = [
    var.terraform-role,
    "arn:aws:iam::${var.account-id}:role/Admin",
    "arn:aws:iam::${var.account-id}:role/Terraform",
  ]
  source = "../terraform-role"
}

output "outputs" {
  value = {
    terraform-role-arn = module.iam.outputs.arn
    account-id         = aws_organizations_account.main.id
  }
}
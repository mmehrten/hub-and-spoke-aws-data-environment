resource "aws_security_group" "main" {
  name        = "${var.base-name}.sg.quicksight"
  description = "Quicksight Security Group"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow all inbound connections"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    description      = "Allow all inbound connections"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "${var.base-name}.sg.quicksight"
  }
}

locals {
  iam_identities = {
    "Government" : ""
    "Financial" : ""
    "Commercial" : ""
    "Restricted" : ""
  }
  identities = {
    "Government" : ""
    "Financial" : ""
    "Commercial" : ""
  }
}

module "users" {
  for_each           = local.iam_identities
  region             = var.region
  account-id         = var.account-id
  app-shorthand-name = var.app-shorthand-name
  app-name           = var.app-name
  terraform-role     = var.terraform-role
  tags               = var.tags
  base-name          = var.base-name
  pgp-key            = var.pgp-key
  name               = "${each.key}User"
  source             = "../console-user"
}

resource "aws_quicksight_group" "main" {
  for_each   = local.identities
  group_name = "${each.key}Consumers"
}


resource "aws_quicksight_user" "main" {
  for_each      = local.identities
  email         = "${each.key}@ac.com"
  identity_type = "IAM"
  iam_arn       = module.users[each.key].secrets.arn
  user_role     = "READER"
  user_name     = "${each.key}User"
}

resource "aws_quicksight_group_membership" "main" {
  for_each    = aws_quicksight_user.main
  group_name  = "${each.key}Consumers"
  member_name = "${each.key}User"
}

resource "aws_lakeformation_permissions" "db" {
  for_each                      = local.table-permissions
  principal                     = each.value.principal
  permissions                   = ["DESCRIBE"]
  permissions_with_grant_option = ["DESCRIBE"]
  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = each.value.key
      values = each.value.values
    }
    catalog_id = each.value.catalog_id

  }
}

resource "aws_lakeformation_permissions" "table" {
  for_each                      = local.table-permissions
  principal                     = each.value.principal
  permissions                   = ["DESCRIBE", "SELECT"]
  permissions_with_grant_option = ["DESCRIBE", "SELECT"]
  lf_tag_policy {
    resource_type = "TABLE"

    expression {
      key    = each.value.key
      values = each.value.values
    }
    catalog_id = each.value.catalog_id
  }

}

output "users" {
  value = module.users
}
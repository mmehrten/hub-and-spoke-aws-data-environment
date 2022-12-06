resource "aws_iam_user" "users" {
  for_each = var.users
  name     = each.key
  path     = "/users/"
}

resource "aws_iam_user_group_membership" "users-groups" {
  for_each = var.users
  user     = each.key
  groups   = each.value.groups
}

resource "aws_iam_user_login_profile" "users-profiles" {
  for_each = var.users
  user     = each.key
}

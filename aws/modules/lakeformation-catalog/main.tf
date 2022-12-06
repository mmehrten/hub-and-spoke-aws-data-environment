resource "aws_lakeformation_data_lake_settings" "main" {
  admins = [var.terraform-role, "arn:${var.partition}:iam::${var.account-id}:role/Admin"]
}
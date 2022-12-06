data "aws_iam_policy_document" "main-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.runner-role-arns
    }
    sid = "AllowAdminToAssume"
  }
}
resource "aws_iam_role" "main" {
  name                = "Terraform"
  assume_role_policy  = data.aws_iam_policy_document.main-assume-role.json
  managed_policy_arns = ["arn:${var.partition}:iam::aws:policy/AdministratorAccess"]
}
output "outputs" {
  value = {
    arn = aws_iam_role.main.arn
  }
}
resource "aws_iam_user" "main" {
  name          = var.name
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "main" {
  user    = aws_iam_user.main.name
  pgp_key = var.pgp-key
}

resource "aws_iam_user_policy_attachment" "main" {
  user       = aws_iam_user.main.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "main" {
  user    = aws_iam_user.main.name
  pgp_key = var.pgp-key
}

output "secrets" {
  value = {
    "arn" : aws_iam_user.main.arn
    "console" : aws_iam_user_login_profile.main.encrypted_password,
    "access_key_id" : aws_iam_access_key.main.id,
    "secret_access_key" : aws_iam_access_key.main.encrypted_secret,
  }
}
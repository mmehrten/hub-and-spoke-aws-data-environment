output "outputs" {
  value = {
    "users" : { for o in values(aws_iam_user.config-users) : o.name => { "arn" = o.arn } }
  }
  description = "A map of the users and their ARNs that are provisioned based on the input variables."
}
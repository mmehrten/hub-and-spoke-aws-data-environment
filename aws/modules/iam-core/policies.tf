resource "aws_iam_policy" "policies" {
  for_each    = var.policies
  name        = each.key
  description = each.value.description
  path        = "/"
  policy      = lookup(each.value, "policy", null) == null ? file("iam_policies/${each.key}.json") : lookup(each.value, "policy")
}

locals {
  policies = {
    for obj in concat(values(aws_iam_policy.policies), var.builtin_policies) :
    "${obj.name}" => {
      name = obj.name
      arn  = obj.arn
    }
  }
}

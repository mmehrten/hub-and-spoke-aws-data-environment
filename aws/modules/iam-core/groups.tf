resource "aws_iam_group" "config-groups" {
  for_each = var.groups
  name     = each.key
  path     = "/users/"
}

locals {
  policy-attachments = { for o in flatten(
    [for g in var.groups :
      [for p in g.policies :
        {
          policy_name : p
          group : g.key
        }
  ]]) : "${o.policy_name}-${o.group}" => o }
}

resource "aws_iam_group_policy_attachment" "config-groups-policies" {
  for_each   = local.policy-attachments
  group      = each.value.group
  policy_arn = local.policies[each.value.policy_name].arn
}

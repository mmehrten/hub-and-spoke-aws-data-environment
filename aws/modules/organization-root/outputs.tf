output "outputs" {
  value = {
    id  = aws_organizations_organization.main.id
    arn = aws_organizations_organization.main.arn
  }
  description = "A mapping containing organization outputs like the ID and ARN."
}

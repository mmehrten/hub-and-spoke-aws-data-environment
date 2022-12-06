variable "runner-role-arns" {
  description = "The ARNs of the roles which can assume and run the Terraform role."
  type        = list(string)
}
variable "region" {
  type        = string
  description = "The region to create resources in."
  default     = "us-east-1"
}
variable "partition" {
  type        = string
  description = "The partition to create resources in."
  default     = "aws"
}
variable "terraform-role" {
  type        = string
  description = "The IAM role ARN to execute terraform with."
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
}
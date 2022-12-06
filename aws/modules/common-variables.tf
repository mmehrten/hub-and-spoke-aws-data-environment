terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.44.0"
    }
  }
}
variable "org-shorthand-name" {
  type        = string
  description = "The organization's descriptor, shorthand (e.g. Any Company -> ac)"
  default     = "ac"
}
variable "region" {
  type        = string
  description = "The region to create resources in."
}
variable "partition" {
  type        = string
  description = "The partition to create resources in."
  default     = "aws"
}
variable "account-id" {
  type        = string
  description = "The account to create resources in."
}
variable "app-shorthand-name" {
  type        = string
  description = "The shorthand name of the app being provisioned."
}
variable "app-name" {
  type        = string
  description = "The longhand name of the app being provisioned."
}
variable "terraform-role" {
  type        = string
  description = "The role for Terraform to use, which dictates the account resources are created in."
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
}
variable "base-name" {
  type        = string
  description = "The base name to create new resources with (e.g. {app_shorthand}.{region})."
}
provider "aws" {
  region = var.root-region
  assume_role { role_arn = var.terraform-role }
  default_tags { tags = var.tags }
}
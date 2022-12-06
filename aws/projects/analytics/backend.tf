terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.44.0"
    }
  }
  backend "s3" {
    bucket         = "ac-core-zwy2.us-east-1.s3.terraform"
    key            = "ac-analytics-zwy2/state/prod.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ac-core-zwy2.us-east-1.dynamodb.terraform"
  }
}
/*
*   Create a root organization with CloudTrail and Config service principals, and all features enabled.
*/
resource "aws_organizations_organization" "main" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
  feature_set = "ALL"
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.base-name}.cloudtrail.organization"
  s3_bucket_name                = var.logs-bucket
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
}
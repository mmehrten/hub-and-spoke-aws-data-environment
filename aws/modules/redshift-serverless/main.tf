/*
* Create a Redshift culster.
*/

resource "aws_security_group" "main" {
  name        = "${var.base-name}.sg.redshift-serverless"
  description = "Security group for Redshift clusters."
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow all inbound connections"
    from_port        = 5439
    to_port          = 5439
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "${var.base-name}.sg.redshift-serverless"
  }
}

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [var.vpc-id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = [false]
  }
}


resource "aws_iam_role" "main" {
  name               = "${var.base-name}.iam.role.redshift-serverless"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "redshift.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"
}

resource "aws_iam_role_policy" "main" {
  name   = "${var.base-name}.iam.role.redshift-serverless"
  role   = aws_iam_role.main.id
  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": "s3:*",
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_kms_key" "main" {
  description             = "Redshift Serverless KMS key."
  deletion_window_in_days = 30
  enable_key_rotation     = "true"
  tags = {
    "Name" = "${var.base-name}.kms.redshift-serverless"
  }
}

resource "aws_redshiftserverless_namespace" "main" {
  namespace_name      = "redshift-core"
  admin_username      = "admin"
  admin_user_password = var.master-password
  db_name             = var.database-name
  iam_roles           = [aws_iam_role.main.arn]
  kms_key_id          = aws_kms_key.main.arn
  log_exports         = ["connectionlog", "userlog", "useractivitylog"]
  lifecycle {
    ignore_changes = [iam_roles]
  }
}

resource "aws_redshiftserverless_workgroup" "main" {
  namespace_name       = "redshift-core"
  workgroup_name       = "redshift-core"
  enhanced_vpc_routing = true
  publicly_accessible  = false
  security_group_ids   = [aws_security_group.main.id]
  subnet_ids           = data.aws_subnets.main.ids
  config_parameter {
    parameter_key   = "enable_user_activity_logging"
    parameter_value = true
  }
  lifecycle {
    ignore_changes = [config_parameter]
  }
}
// Add an alias to Redshift in DNS
data "aws_route53_zone" "main" {
  name         = var.route-53-zone
  private_zone = true
}
data "aws_vpc_endpoint" "redshift" {
  id = aws_redshiftserverless_workgroup.main.endpoint[0].vpc_endpoint[0].vpc_endpoint_id
}
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "redshift-serverless"
  type    = "A"
  alias {
    zone_id                = data.aws_vpc_endpoint.redshift.dns_entry[0].hosted_zone_id
    name                   = data.aws_vpc_endpoint.redshift.dns_entry[0].dns_name
    evaluate_target_health = true
  }
}
output "jdbc-url" {
  value = "jdbc:redshift://redshift-serverless.${var.app-shorthand-name}.${var.org-shorthand-name}.aws.local:${aws_redshiftserverless_workgroup.main.endpoint[0].port}/${var.database-name}"
}
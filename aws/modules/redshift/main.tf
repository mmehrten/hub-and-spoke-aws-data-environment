/*
* Create a Redshift culster.
*/

resource "aws_security_group" "main" {
  name        = "${var.base-name}.sg.redshift"
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
    Name = "${var.base-name}.sg.endpoint"
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

resource "aws_redshift_subnet_group" "main" {
  name       = "redshift-subnet-group"
  subnet_ids = data.aws_subnets.main.ids
}


resource "aws_iam_role" "main" {
  name               = "${var.base-name}.iam.role.redshift"
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


resource "aws_iam_role_policy" "main" {
  name   = "${var.base-name}.iam.role.redshift"
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
  description             = "Redshift KMS key."
  deletion_window_in_days = 30
  enable_key_rotation     = "true"
  tags = {
    "Name" = "${var.base-name}.kms.redshift"
  }
}

resource "aws_redshift_cluster" "main" {
  cluster_identifier = "redshift-cluster"
  database_name      = var.database-name
  master_username    = "admin"
  master_password    = var.master-password
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  vpc_security_group_ids    = [aws_security_group.main.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.main.id
  skip_final_snapshot       = true
  publicly_accessible       = false
  encrypted                 = true
  kms_key_id                = aws_kms_key.main.arn
  iam_roles                 = [aws_iam_role.main.arn]
  logging {
    enable               = true
    log_destination_type = "cloudwatch"
    log_exports          = ["connectionlog", "userlog", "useractivitylog"]
  }
}
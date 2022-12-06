/*
*   Create a VPC interface endpoints for the configured services, and a gateway endpoint for S3.
*/

data "aws_subnet" "main" {
  for_each = var.subnet-ids
  id       = each.value
}

locals {
  endpoints_map = { for o in var.endpoints : o => o }
}


resource "aws_vpc_endpoint" "s3-gateway" {
  vpc_id              = var.vpc-id
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false
  route_table_ids     = var.route-table-ids

  tags = {
    Name = "${var.base-name}.vpce.s3"
  }
}

resource "aws_security_group" "endpoint-security-group" {
  name        = "${var.base-name}.sg.endpoint"
  description = "Security group which contains relationships with all VPC endpoints."
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow all inbound connections"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "${var.base-name}.sg.endpoint"
  }
}

resource "aws_vpc_endpoint" "access" {
  for_each            = local.endpoints_map
  vpc_id              = var.vpc-id
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  security_group_ids  = [aws_security_group.endpoint-security-group.id]
  subnet_ids          = [for o in values(var.subnet-ids) : o]

  timeouts {
    create = "45m"
  }

  tags = {
    Name = "${var.base-name}.vpce.${each.value}"
  }
}

locals {
  route_53_aliases = {
    for o in flatten([
      for key, value in aws_vpc_endpoint.access :
      { "zone_id" : value.dns_entry[0].hosted_zone_id, "dns_name" : value.dns_entry[0].dns_name, "service_name" : "${key}.${var.region}.amazonaws.com" }
      ]
    ) :
    o.service_name => o
  }
}

resource "aws_route53_zone" "main" {
  for_each = local.route_53_aliases

  name = each.value.service_name
  vpc {
    vpc_id = var.vpc-id
  }
  lifecycle { ignore_changes = [vpc] }
  tags = {
    "zone-service" : each.key
  }
}

resource "aws_route53_record" "main" {
  for_each = local.route_53_aliases
  zone_id  = aws_route53_zone.main[each.key].zone_id
  name     = each.value.service_name
  type     = "A"
  alias {
    zone_id                = each.value.zone_id
    name                   = each.value.dns_name
    evaluate_target_health = true
  }
}

// Create an org-wide DNS hosted zone for cross-account resource sharing when needed
resource "aws_route53_zone" "org" {
  name = "${var.org-shorthand-name}.aws.local"
  vpc {
    vpc_id = var.vpc-id
  }
  lifecycle { ignore_changes = [vpc] }
  tags = {
    "zone-service" : var.app-shorthand-name
  }
}

output "outputs" {
  value = {
    zone_ids = {
      for key, value in aws_route53_zone.main :
      key => value.zone_id
    }
  }
}
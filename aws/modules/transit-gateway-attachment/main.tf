/*
* Attach a VPC to a transit gateway.
*
* Assumes that you already have a route table and tgw, and that your route table is associated with
* your current subnets.
*/
resource "aws_ec2_transit_gateway" "peer" {
  description                     = "Transit gateway for peer account VPC access."
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "${var.base-name}.tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids                                      = var.subnet-ids
  transit_gateway_id                              = aws_ec2_transit_gateway.peer.id
  vpc_id                                          = var.vpc-id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.base-name}.tgw.attachment.vpc"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment" "main" {
  peer_account_id         = var.root-account-id
  peer_region             = var.root-region
  peer_transit_gateway_id = var.transit-gateway-id
  transit_gateway_id      = aws_ec2_transit_gateway.peer.id

  tags = {
    Name = "${var.base-name}.tgw.attachment.peer"
    Side = "Creator"
  }
}

resource "aws_ec2_transit_gateway_route_table" "main" {
  transit_gateway_id = aws_ec2_transit_gateway.peer.id
  tags = {
    Name = "${var.base-name}.tgw.rtb"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

data "aws_ec2_transit_gateway_peering_attachment" "accepter" {
  provider   = aws.root
  depends_on = [aws_ec2_transit_gateway_peering_attachment.main]
  filter {
    name   = "transit-gateway-id"
    values = [var.transit-gateway-id]
  }
  filter {
    name   = "state"
    values = ["pending", "available", "pendingAcceptance"]
  }
  filter {
    name   = "remote-owner-id"
    values = [var.account-id]
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "main" {
  provider                      = aws.root
  transit_gateway_attachment_id = data.aws_ec2_transit_gateway_peering_attachment.accepter.id
  tags = {
    Name = "${var.base-name}.tgw.attachment.peer"
    Side = "Acceptor"
  }
}

# Add a peer route table association to the peering connection
resource "aws_ec2_transit_gateway_route_table_association" "peer" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

data "aws_ec2_transit_gateway_route_table" "root" {
  provider = aws.root
  filter {
    name   = "transit-gateway-id"
    values = [var.transit-gateway-id]
  }
}

# Add a peer route table association to the root connection
resource "aws_ec2_transit_gateway_route_table_association" "root" {
  provider                       = aws.root
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.accepter.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.root.id
}

# A peer's traffic should always route to the root TGW peer - Only the peer's in-VPC traffic should route in-VPC
resource "aws_ec2_transit_gateway_route" "peer-root" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
resource "aws_ec2_transit_gateway_route" "peer-internal" {
  destination_cidr_block         = var.cidr-block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
data "aws_route_table" "peer" {
  filter {
    name   = "tag:Name"
    values = ["*private"]
  }
}
resource "aws_route" "peer-root" {
  route_table_id         = data.aws_route_table.peer.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.peer.id
}
# The root's traffic should route to the peer only if it's the peer's CIDR
resource "aws_ec2_transit_gateway_route" "root-peer" {
  provider                       = aws.root
  destination_cidr_block         = var.cidr-block
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_peering_attachment.accepter.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.root.id
}
data "aws_route_table" "root" {
  provider = aws.root
  filter {
    name   = "tag:Name"
    values = ["*private"]
  }
}
resource "aws_route" "root-peer" {
  provider               = aws.root
  route_table_id         = data.aws_route_table.root.id
  destination_cidr_block = var.cidr-block
  transit_gateway_id     = var.transit-gateway-id
}

# Peer the PHZ from the core account to the peer account
locals {
  service-endpoints = {
    for o in [
      "airflow.api",
      "airflow.env",
      "airflow.ops",
      "ecr.api",
      "ecr.dkr",
      "kms",
      "logs",
      "monitoring",
      "sqs",
      "elasticmapreduce",
      "ecs",
      "rds",
      "secretsmanager",
      "ssm",
      "ec2messages",
      "ssmmessages",
    ] :
    o => "${o}.${var.region}.amazonaws.com"
  }
}
data "aws_route53_zone" "main" {
  provider     = aws.root
  for_each     = local.service-endpoints
  name         = each.value
  private_zone = true
}

resource "aws_route53_vpc_association_authorization" "root" {
  provider = aws.root
  for_each = data.aws_route53_zone.main
  vpc_id   = var.vpc-id
  zone_id  = each.value.zone_id
}
resource "aws_route53_zone_association" "peer" {
  for_each = aws_route53_vpc_association_authorization.root
  vpc_id   = each.value.vpc_id
  zone_id  = each.value.zone_id
}

// Create DNS zone for spoke account resources and peer to the root account
resource "aws_route53_zone" "peer-dns" {
  name = "${var.app-shorthand-name}.${var.org-shorthand-name}.aws.local"
  vpc {
    vpc_id = var.vpc-id
  }
  lifecycle { ignore_changes = [vpc] }
  tags = {
    "zone-service" : var.app-shorthand-name
  }
}
data "aws_vpc" "root" {
  provider = aws.root
  filter {
    name   = "state"
    values = ["available"]
  }
}
resource "aws_route53_vpc_association_authorization" "peer-dns-root" {
  vpc_id  = data.aws_vpc.root.id
  zone_id = aws_route53_zone.peer-dns.zone_id
}
resource "aws_route53_zone_association" "root-peer-dns" {
  provider = aws.root
  vpc_id   = aws_route53_vpc_association_authorization.peer-dns-root.vpc_id
  zone_id  = aws_route53_vpc_association_authorization.peer-dns-root.zone_id
}

// Join to the root account's DNS zone
data "aws_route53_zone" "root-dns" {
  provider     = aws.root
  name         = "${var.org-shorthand-name}.aws.local"
  private_zone = true
}
resource "aws_route53_vpc_association_authorization" "root-dns-peer" {
  provider = aws.root
  vpc_id   = var.vpc-id
  zone_id  = data.aws_route53_zone.root-dns.zone_id
}
resource "aws_route53_zone_association" "peer-root-dns" {
  vpc_id  = aws_route53_vpc_association_authorization.root-dns-peer.vpc_id
  zone_id = aws_route53_vpc_association_authorization.root-dns-peer.zone_id
}

output "route-53-zone" {
  value = aws_route53_zone.peer-dns.name
}
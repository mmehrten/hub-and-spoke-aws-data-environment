/*
*   Create a VPC with configured public and private subnets, with a public and private route table.
*/
resource "aws_vpc" "main" {
  cidr_block           = var.cidr-block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.base-name}.vpc"
    Description = "VPC for ${var.app-name}"
  }
}

resource "aws_subnet" "public" {
  count      = length(var.public-subnets)
  cidr_block = element(values(var.public-subnets), count.index)
  vpc_id     = aws_vpc.main.id

  map_public_ip_on_launch = true
  availability_zone       = element(keys(var.public-subnets), count.index)

  tags = {
    Name = "${var.base-name}.subnet.public.${count.index}"
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private-subnets)
  cidr_block = element(values(var.private-subnets), count.index)
  vpc_id     = aws_vpc.main.id

  map_public_ip_on_launch = false
  availability_zone       = element(keys(var.private-subnets), count.index)

  tags = {
    Name = "${var.base-name}.subnet.private.${count.index}"
  }
}

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.base-name}.rtb.public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.base-name}.rtb.private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private-subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false
  route_table_ids     = [aws_route_table.private.id, aws_default_route_table.public.id]

  tags = {
    Name = "${var.base-name}.vpce.s3"
  }
}

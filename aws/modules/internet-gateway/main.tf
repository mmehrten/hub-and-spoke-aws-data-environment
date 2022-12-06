/*
* Create an internet gateway in a public subnet.
*/

resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc-id

  tags = {
    Description = "Allow inbound / outbound internet connections to VPC from public subnet"
    Name        = "${var.base-name}.igw"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = var.route-table-id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = var.subnet-ids
  subnet_id      = each.value
  route_table_id = var.route-table-id
}

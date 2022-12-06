output "outputs" {
  value = {
    public-subnet-ids : { for o in aws_subnet.public : o.cidr_block => o.id }
    private-subnet-ids : { for o in aws_subnet.private : o.cidr_block => o.id }
    availability-zones : [for o in keys(var.public-subnets) : o]
    vpc-id : aws_vpc.main.id
    public-route-table-id : aws_default_route_table.public.id
    private-route-table-id : aws_route_table.private.id
  }
  description = "A mapping containing VPC outputs like the public/private subnet IDs, VPC ID, route table IDs, etc."
}

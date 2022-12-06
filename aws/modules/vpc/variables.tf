variable "cidr-block" {
  type        = string
  description = "The root CIDR block for the VPC"
}
variable "public-subnets" {
  type        = map(string)
  description = "A mapping of Availability Zone to the CIDR block for the subnet in that AZ."
}
variable "private-subnets" {
  type        = map(string)
  description = "A mapping of Availability Zone to the CIDR block for the subnet in that AZ."
}


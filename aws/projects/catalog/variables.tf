variable "root-account-id" {
  type        = string
  description = "The account ID of the root (hub networking) account."
}
variable "root-region" {
  type        = string
  description = "The region where the root transit gateway is deployed."
}
variable "app-name" {
  type        = string
  description = "The name of the spoke app to deploy."
}
variable "app-shorthand-name" {
  type        = string
  description = "The shorthand name to use in resource naming."
}
variable "owner-email" {
  type        = string
  description = "The email for the spoke account owner, required if creat-account is true."
  default     = ""
}
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
variable "root-transit-gateway-id" {
  type        = string
  description = "Transit gateway ID for the root AWS account networking VPC"
}
variable "pgp-key" {
  type        = string
  description = "Optional PGP key if creating a console user"
  default     = ""
}
variable "root-account-id" {
  type        = string
  description = "The account ID of the root (hub networking) account."
}
variable "catalog-account-id" {
  type        = string
  description = "The account ID of the data catalog account."
}
variable "catalog-terraform-role" {
  type        = string
  description = "The IAM role ARN to execute terraform with in the data catalog account."
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
variable "redshift-master-password" {
  type        = string
  description = "The master password for the Redshift admin user"
}
variable "lf-tags" {
  type        = map(any)
  description = "A map of key-value pairs for LF tags in Lake Formation"
}
variable "databases" {
  type        = map(any)
  description = "A map of key-value pairs for the databases to create and LF tags to apply."
}
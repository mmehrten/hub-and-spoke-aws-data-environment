variable "account-id" {
  type        = string
  description = "The account to create resources in."
}
variable "app-shorthand-name" {
  type        = string
  description = "The shorthand name of the app being provisioned."
}
variable "app-name" {
  type        = string
  description = "The longhand name of the app being provisioned."
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
variable "enable-transitgateway" {
  type        = bool
  default     = true
  description = "Whether or not to include a Transit Gateway"
}
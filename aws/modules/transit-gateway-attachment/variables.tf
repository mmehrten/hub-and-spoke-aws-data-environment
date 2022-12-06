variable "transit-gateway-id" {
  description = "The ID of the transit gateway to attach to."
  type        = string
}
variable "root-account-id" {
  description = "The ID of the transit gateway to attach to."
  type        = string
}
variable "root-region" {
  description = "The ID of the transit gateway to attach to."
  type        = string
}
variable "subnet-ids" {
  description = "The subnet IDs in the main VPC to attach the TGW to."
  type        = list(string)
}
variable "vpc-id" {
  description = "The ID of the VPC to attach the TGW to, should be the root VPC."
  type        = string
}
variable "cidr-block" {
  description = "The CIDR of the spoke VPC"
  type        = string
}

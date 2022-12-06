variable "subnet-ids" {
  description = "The subnet IDs in the main VPC to attach the TGW to."
  type        = list(string)
}

variable "vpc-id" {
  description = "The ID of the VPC to attach the TGW to, should be the root VPC."
  type        = string
}

variable "pgp-key" {
  type        = string
  description = "PGP key to use for user password encryption"
}
variable "vpc-id" {
  type        = string
  description = "The VPC to run Quicksight in."
}
variable "table-permissions" {
  description = "A mapping of principals and the tags / catalogs that those principals need access to in Lake Formation for Quicksight"
  type = any
  default = {}
}

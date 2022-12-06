variable "database-name" {
  description = "The Redshift database name"
  default     = "dev"
  type        = string
}
variable "vpc-id" {
  description = "The VPC to create the cluster in"
  type        = string
}
variable "master-password" {
  description = "The cluster admin user password"
  type        = string
}
variable "route-53-zone" {
  description = "The Route53 zone for the spoke network"
  type        = string
}
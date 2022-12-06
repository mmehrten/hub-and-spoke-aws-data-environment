variable "databases" {
  type        = map(any)
  description = "A map of key-value pairs for the databases to create and LF tags to apply."
}
variable "crawlers" {
  type        = map(any)
  description = "A map of key-value pairs for the crawlers to create."
}
variable "lf-tags" {
  type        = map(any)
  description = "A map of key-value pairs for LF tags in Lake Formation"
}
variable "read-bucket-arns" {
  type        = list(string)
  description = "The ARNs for buckets with read access."
}
variable "write-bucket-arns" {
  type        = list(string)
  description = "The ARNs for buckets with write access."
}
variable "vpc-id" {
  type        = string
  description = "The VPC to run Glue in."
}
variable "catalog-account-id" {
  description = "The ID of the transit gateway to attach to."
  type        = string
}
variable "lf-tag-shares" {
  description = "Mapping of principals to share data with by LF tag"
}
variable "redshift-password" {
  description = "The password to use for a Redshift Serverless connection"
  type        = string
}
variable "redshift-jdbc-url" {
  description = "The JDBC endpoint URL to use for a Redshift Serverless connection"
  type        = string
}
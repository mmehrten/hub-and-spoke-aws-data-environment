variable "table-name" {
  description = "The table name."
  type        = string
}
variable "billing-mode" {
  description = "The table billing mode."
  type        = string
  default     = "PAY_PER_REQUEST"
}
variable "hash-key" {
  description = "The table object hashing key."
  type        = string
}
variable "hash-type" {
  description = "The table object hashing key type."
  default     = "S"
  type        = string
}

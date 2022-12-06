/*
* Create a basic DynamoDB table.
*/

resource "aws_dynamodb_table" "main" {
  name         = var.table-name
  billing_mode = var.billing-mode
  hash_key     = var.hash-key
  attribute {
    name = var.hash-key
    type = var.hash-type
  }
}

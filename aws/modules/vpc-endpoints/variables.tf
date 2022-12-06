variable "endpoints" {
  type        = list(string)
  description = "A list of the services to create interface endpoints for."
  default = [
    "airflow.api",
    "airflow.env",
    "airflow.ops",
    "ecr.api",
    "ecr.dkr",
    "kms",
    "logs",
    "monitoring",
    "sqs",
    "elasticmapreduce",
    "ecs",
    "rds",
    "secretsmanager",
    "ssm",
    "ec2messages",
    "ssmmessages",
  ]
}
variable "subnet-ids" {
  type        = map(string)
  description = "A map of the subnet IDs to associate the gateways with."
}
variable "vpc-id" {
  type        = string
  description = "The VPC ID to create the gateways in."
}
variable "route-table-ids" {
  type        = list(string)
  description = "The route table IDs to associate the gateways with."
}
variable "name" {
  description = "Name prefix for IAM resources"
  type        = string
}

variable "db_master_secret_arn" {
  description = "ARN of the database secret in AWS Secrets Manager"
  type        = string
}
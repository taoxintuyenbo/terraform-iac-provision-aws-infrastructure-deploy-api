output "db_master_secret_arn" {
    value = aws_db_instance.mydb.master_user_secret[0].secret_arn
}

output "db_endpoint" {
  value = aws_db_instance.mydb.address
}
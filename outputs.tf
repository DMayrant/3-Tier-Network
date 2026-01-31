output "rds_endpoint" {
  value = aws_db_instance.lab_mysql.address
}

output "rds_port" {
  value = aws_db_instance.lab_mysql.port
}
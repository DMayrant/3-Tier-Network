resource "aws_secretsmanager_secret" "rds_mysql" {
  name        = "lab/rds/mysql"
  description = "MySQL credentials for lab RDS instance"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_mysql_version" {
  secret_id = aws_secretsmanager_secret.rds_mysql.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine   = "mysql"
    host     = aws_db_instance.lab_mysql.address
    port     = 3306
    dbname   = var.db_name
  })
}

resource "random_password" "db_password" {
  length  = 10
  special = true
}

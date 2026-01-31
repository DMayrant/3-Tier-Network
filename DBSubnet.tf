resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "lab-mysql-subnet-group-${var.env}"
  subnet_ids = aws_subnet.private_subnet[*].id

  tags = {
    Name = "mysql-subnet-group"
  }
}
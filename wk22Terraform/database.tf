#Wk22 Module Database

#Configure private subnets created in VPC
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql_subnet_group"
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Name = "${var.name}-subnet_group"
  }
}

#Launch one RDS MySQL instance in a private subnet 
resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  max_allocated_storage  = 20
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  db_name                = "wk22_mysql"
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t3.micro"
  publicly_accessible    = false
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  storage_encrypted      = true
  deletion_protection    = false
  port                   = 3306

  tags = {
    name = "wk22-mysql"
  }
}


#wk22 Module DB-Security Group
#Create security group for database tier from the web-server tier

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "mysql_sg"
  vpc_id      = aws_vpc.wk22_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "wk22-mysql_sg"
  }
}
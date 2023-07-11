#Wk22 Database Security Group
#From the web-server tier

resource "aws_security_group" "wk22db-sg" {
  name   = "wk22db-sg"
  vpc_id = aws_vpc.wk22-vpc.id

  ingress {
    description     = "Allow mySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = var.tcp
    security_groups = [aws_security_group.wk22db-sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = var.egress-all
    to_port     = var.egress-all
    protocol    = var.egress
    cidr_blocks = [var.cidr]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "wk22-DB-SG"
  }
}
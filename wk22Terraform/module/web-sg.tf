#wk22 Web Tier Security Group

#Create a security group that allows traffic from the internet 
resource "aws_security_group" "web-tier-sg" {
  name   = "wk22-sg-web"
  vpc_id = aws_vpc.wk22-vpc.id

  ingress {
    description = "Allow all SSH"
    from_port   = var.SSH
    to_port     = var.SSH
    protocol    = var.tcp
    cidr_blocks = [var.web-cidr]
  }

  ingress {
    description = "Allow all HTTP"
    from_port   = var.HTTP
    to_port     = var.HTTP
    protocol    = var.tcp
    cidr_blocks = [var.web-cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = var.egress-all
    to_port     = var.egress-all
    protocol    = var.egress
    cidr_blocks = [var.web-cidr]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "wk22-web-sg"
  }
}
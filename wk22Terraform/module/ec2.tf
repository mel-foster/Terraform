#EC2 Configuration

#Obtain public subnets created in VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.wk22-vpc.id]
  }

  tags = {
    Tier = "public"
  }
}

#Launch an EC2 instance with bootstrapped Apache in each public subnet
resource "aws_instance" "wk22EC2" {
  count                       = 2
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web-tier-sg.id]
  user_data                   = filebase64("script.sh")
  user_data_replace_on_change = true
  associate_public_ip_address = true

  tags = {
    Name        = "wk22-EC2r"
    Environment = "dev"
  }
}
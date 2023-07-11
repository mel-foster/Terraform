#wk22 Web Servers

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
resource "aws_instance" "web-server" {
  for_each                    = toset(data.aws_subnets.public.ids)
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = each.value
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.wk22-sg-web.id]
  user_data                   = file("script.sh")
  user_data_replace_on_change = true
  associate_public_ip_address = true

  tags = {
    Name        = "wk22_EC2"
    Environment = "dev"
  }
}
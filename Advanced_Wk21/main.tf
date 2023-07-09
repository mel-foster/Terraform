#main.tf for wk21

#Create S3 bucket  PRIVATE BY DEFAULT
resource "aws_s3_bucket" "s3bucket-week21-melfoster" {
  bucket = "s3bucket-week21-melfoster"

  tags = {
    Name         = "Wk21 S3 Bucket"
    Environement = "development"
  }
}

#Enable versioning
resource "aws_s3_bucket_versioning" "s3bucket-week21-melfoster" {
  bucket = aws_s3_bucket.s3bucket-week21-melfoster.id

  versioning_configuration {
    status = "Enabled"
  }
}
#Block public access to the S3 bucket created above
resource "aws_s3_bucket_public_access_block" "s3bucket-week21-melfoster-accessblock" {
  bucket = aws_s3_bucket.s3bucket-week21-melfoster.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Create VPC 
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "wk21VPC"
  }
}
#AWS Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Security Group Resources
# Security Group Automatic Load Blancer Resource
resource "aws_security_group" "autobalance-security-group" {
  name        = "${var.environment}-autobalance-security-group"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-autobalance-security-group"
  }
}

#Security Group Automatic Scaling Group Resource
resource "aws_security_group" "autoscale-security-group" {
  name        = "${var.environment}-autoscale-security-group"
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.autobalance-security-group.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-autoscale-security-group"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "wk21Internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Wk21_IG"
  }
}

#2Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("-", ["${var.environment}-public-subnet", data.aws_availability_zones.available.names[count.index]])
  }
}

#2Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("-", ["${var.environment}-private-subnet", data.aws_availability_zones.available.names[count.index]])
  }
}

#Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wk21Internet_gateway.id
  }
  tags = {
    Name = "${var.environment}-public-route-table"
  }
}
#Create an Elastic IP making instance accessible from the internet
resource "aws_eip" "elastic_ip" {
  tags = {
    Name = "${var.environment}-elastic-ip"
  }
}

#Create a NAT Gateway allowing instances in private subnet access to internet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.wk21Internet_gateway]
  tags = {
    Name = "WK21NATIG"
  }
}

# Application Load Balancer Resources
resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.autobalance-security-group.id]
  subnets            = [for i in aws_subnet.public_subnet : i.id]
}

#Target Group
resource "aws_lb_target_group" "target_group" {
  name     = "${var.environment}-tgrp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path    = "/"
    matcher = 499
  }
}

#Application Load Balancer Listenter
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  tags = {
    Name = "${var.environment}-alb-listenter"
  }
}

#Auto Scaling Group to automatically scale # of EC2 Instances
resource "aws_autoscaling_group" "auto_scaling_group" {
  name             = "my-autoscaling-group"
  desired_capacity = 2
  max_size         = 5
  min_size         = 2
  vpc_zone_identifier = flatten([
    aws_subnet.private_subnet.*.id,
  ])
  target_group_arns = [
    aws_lb_target_group.target_group.arn,
  ]
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}

#Route Table to direct traffic to NAT Gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.environment}-private-route-table"
  }
}

#Create Public Route Table for Public Subnets
resource "aws_route_table_association" "public_rt_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
#Create a Private Route Table for Private subnets
resource "aws_route_table_association" "private_rt_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Launch Template and ASG Resources
resource "aws_launch_template" "ec2_launch_template" {
  name          = "${var.environment}-launch-template"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  tags = {
    Name = "wk21apache_instance"
  }

  #User Data in AWS EC2
  user_data = base64encode("${var.user_data}")
}

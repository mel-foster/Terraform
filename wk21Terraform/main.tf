#main.tf for wk21

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


# Security Group Automatic Load Blancer Resource
resource "aws_security_group" "alb_wk21sg" {
  name        = "${var.environment}-alb-wk21-sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  #Allow incoming TCP requests on port 80 from any IP
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-alb-wk21-sg"
  }
}

#Security Group Automatic Scaling Group Resource
resource "aws_security_group" "asg_wk21sg" {
  name        = "${var.environment}-asg-wk21sg"
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id

  #Allow incoming TCP requests on port 80 from ALB  
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_wk21sg.id]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-asg-security-group"
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
    gateway_id = aws_internet_gateway.internet_gateway.id
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
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "WK21NATIG"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "WK21_IG"
  }
}

# Application Load Balancer Resources
resource "aws_lb" "wk21alb" {
  name               = "${var.environment}-wk21alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_wk21sg.id]
  subnets            = [for i in aws_subnet.public_subnet : i.id]
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


resource "aws_instance" "ubuntu" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.alb_wk21sg.id]
  tags = {
    Name = "wk21Apache_instance"
  }

  #User Data in AWS EC2
  user_data = file("script.sh")
}

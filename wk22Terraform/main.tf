#Wk22 main

#Define Availability Zone
data "aws_availability_zones" "available" {}

#Create a VPC
resource "aws_vpc" "wk22_vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

#Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.wk22_vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, count.index + 100)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnets[count.index]
  }
}

#Create Private Subnet
resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.wk22_vpc.id
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = var.private_subnets[count.index]
  }
}

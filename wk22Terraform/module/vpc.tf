#WK 22 VPC

#Create custom VPC
resource "aws_vpc" "wk22-vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = var.true
  enable_dns_support   = var.true

  tags = {
    Name = "wk22-vpc"
  }
}

#Obtain availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

#Create 2 public subnets for webserver tier
resource "aws_subnet" "public-subnets" {
  for_each                = var.public-subnets
  vpc_id                  = aws_vpc.wk22-vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value - 1]
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-${each.key}"
    Tier = "public"
  }
}

#Create 2 private subnets for RDS MySQL tier
resource "aws_subnet" "private-subnets" {
  for_each                = var.private-subnets
  vpc_id                  = aws_vpc.wk22-vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value - 1]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-private-${each.key}"
    Tier = "private"
  }
}
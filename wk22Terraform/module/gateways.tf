#Create Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.wk22-vpc.id
  tags = {
    Name = "wk22-igw"
  }
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat-gateway-eip" {
  vpc        = aws_vpc.wk22-vpc.id
  depends_on = [aws_internet_gateway.internet-gateway]
  tags = {
    Name = "wk22-nat-gw-eip"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  depends_on    = [aws_subnet.public-subnets]
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id     = aws_subnet.public-subnets["public-subnet-1"].id
  tags = {
    Name = "wk22-nat-gw"
  }
}
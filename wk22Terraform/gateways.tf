#Create Internet Gateway
resource "aws_internet_gateway" "wk22_igw" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

#Create Elastic IP
resource "aws_eip" "wk22_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.wk22_igw]
}

#Create Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.wk22_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.name}-nat_gateway"
  }
}
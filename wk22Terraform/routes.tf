#Wk 22 Route Tables

#Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wk22_igw.id
  }
  tags = {
    Name = "${var.name}-public_rt"
  }
}

#Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.name}-private-rt"
  }
}

#ROUTE TABLE ASSOCIATIONS

#Public Route Table
resource "aws_route_table_association" "public" {
  for_each       = { for idx, subnet in aws_subnet.public_subnets : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}



#Private Route Table
resource "aws_route_table_association" "private" {
  for_each       = { for idx, subnet in aws_subnet.private_subnets : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}


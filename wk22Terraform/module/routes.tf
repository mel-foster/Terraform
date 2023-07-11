#Wk 22 Route Tables

#Create route table for public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.wk22-vpc.id

  route {
    cidr_block = var.cidr
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "terraform_public_rtb"
    Tier = "public"
  }
}

#Create route table for private subnets 
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.wk22-vpc.id

  route {
    cidr_block     = var.cidr
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "terraform-private-rtb"
    Tier = "private"
  }
}

#Route Table Associations
#Create public route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public-subnets]
  route_table_id = aws_route_table.public-rtb.id
  for_each       = aws_subnet.public-subnets
  subnet_id      = each.value.id
}

#Create private route table associations
resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private-subnets]
  route_table_id = aws_route_table.private-rtb.id
  for_each       = aws_subnet.private-subnets
  subnet_id      = each.value.id
}


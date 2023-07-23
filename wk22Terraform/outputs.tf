#Outputs

output "list_of_az" {
  value = data.aws_availability_zones.available[*].names
}

# output of VPC Id
output "vpc_id" {
  value = aws_vpc.wk22_vpc.id
}


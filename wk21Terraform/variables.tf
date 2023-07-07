#variables for Wk21 main.tf

#AWS Region Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#Environement variable 
variable "environment" {
  description = "Environment name for deployment"
  type        = string
  default     = "wk21Project"
}

# Create VPC Variables using Default
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}


#Create subnets
variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "public_subnet_cidr" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

variable "private_subnet_cidr" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
  ]
}

variable "security_group_name" {
  description = "Name of the security group"
  default     = "wk21sg"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}
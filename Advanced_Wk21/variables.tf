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
  default     = "10.10.0.0/16"
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
    "10.10.0.0/24",
    "10.10.2.0/24",
  ]
}

variable "private_subnet_cidr" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.10.3.0/24",
    "10.10.4.0/24",
  ]
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

#Script to bootstrap Apache
variable "user_data" {
  description = "script to bootsrap Apache Server"
  type        = string
  default     = <<EOF

#! /bin/bash
sudo yum update -y
sudo yum install -y httpd  
sudo systemctl start httpd
sudo systemctl enable httpd  
sudo cat > /var/www/html/index.html << EOF
<html><head><title> Apache 2023 Terraform </title>
</head>
<body>
  <p> Welcome Green Team!! WK21 Terraform ASG by Mel Foster 07/2023
</body>
</html>
EOF
}

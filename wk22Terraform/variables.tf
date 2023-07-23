#Wk22 Variables

#AWS Region Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#Name for Project
variable "name" {
  default = "mel_wk22_project"
}

#VPC Variables
variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

#Subnet Variables  
variable "public_subnets" {
  default = ["public_subnet_1", "public_subnet_2"]
}

variable "private_subnets" {
  default = ["private_subnet_1", "private_subnet2"]
}


#EC2 Variables
variable "instance_ami" {
  type        = string
  description = "AMI ID for the Ubuntu EC2 instance"
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

#Database Variables
variable "password" {}

variable "username" {}
#variables for Wk21 main.tf

#AWS Region Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#Availablity Zones
variable "availability_zones" {
  type    = list(string)
  default = (["us-east-1a", "us-east-1b"])
}


#Environement variable 
variable "environment" {
  description = "Environment name for deployment"
  type        = string
  default     = "wk21Project"
}

variable "vpc_id" {
  description = "ID of the VPC"
  default     = "vpc-06c434ba68f65c898"
}

variable "instance_ami" {
  type        = string
  description = "AMI ID for the Ubuntu EC2 instance"
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
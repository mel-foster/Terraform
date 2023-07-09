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

variable "vpc_cidr_block" {
  type    = string
  default = "172.31.0.0/16"
}

variable "subnet_cidr_block_1" {
  type    = string
  default = "172.31.0.0/20"
}

variable "subnet_cidr_block_2" {
  type    = string
  default = "172.31.32.0/20"
}

variable "subnet_id_1" {
  type    = string
  default = "subnet-0402bdad1ebe688e1"
}

variable "subnet_id_2" {
  type    = string
  default = "subnet-0ca0172094d6d33c4"
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
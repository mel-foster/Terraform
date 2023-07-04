#variables for wk20jenkins

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "security_group_name" {
  description = "Name of the security group"
  default     = "wk20sg_jenkins"
}

variable "vpc_id" {
  description = "ID of the VPC"
  default     = "vpc-06c434ba68f65c898"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}





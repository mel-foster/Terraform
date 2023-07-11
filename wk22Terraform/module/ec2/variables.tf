#EC2 Variables

#ec2 Configurations
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

variable "key_name" {
  description = "EC2 Key Name"
  type        = string
  default     = "wk22-Key"
}
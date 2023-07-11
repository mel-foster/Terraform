#Wk22 Variables

#Availablity Zones
variable "availability_zones" {
  type    = list(string)
  default = (["us-east-1a", "us-east-1b"])
}

#VPC Variables
variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tenancy" {
  type    = string
  default = "default"
}

variable "true" {
  type    = bool
  default = true
}

#Subnet Variables  

variable "public-subnets" {
  default = {
    "public-subnet-1" = 1
    "public-subnet-2" = 2
  }
}

variable "private-subnets" {
  default = {
    "private-subnet-1" = 1
    "private-subnet-2" = 2
  }
}

#Route Table Variable
variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}

#Web Tier Security Group Variables
variable "web-cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "SSH" {
  type    = string
  default = "22"
}

variable "tcp" {
  type    = string
  default = "tcp"
}

variable "HTTP" {
  type    = string
  default = "80"
}

variable "egress-all" {
  type    = string
  default = "0"
}

variable "egress" {
  type    = string
  default = "-1"
}

#EC2 Variables
#Configurations
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

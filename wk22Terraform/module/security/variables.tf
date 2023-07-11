#Wk22 security group variables

variable "cidr" {
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


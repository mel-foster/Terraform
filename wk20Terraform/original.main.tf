#Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Create EC2 instance 
resource "aws_instance" "instance1" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.wk20sg_jenkins.id]
  tags = {
    Name = "wk20jenkins_instance"
  }

  #Bootstrap Jenkins 
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update
  sudo apt install openjdk-11-jre
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install jenkins
  sudo systemctl enablejenkins
  sudo systemtl start jenkins
  EOF

  user_data_replace_on_change = true
}

#Create security group 
resource "aws_security_group" "wk20sg_jenkins" {
  name        = "wk20sg_jenkins"
  description = "Open ports 22, 8080, and 443"

  #Allow incoming TCP requests on port 22 from any IP
  ingress {
    description = "Incoming SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 8080 from any IP
  ingress {
    description = "Incoming 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 443 from any IP
  ingress {
    description = "Incoming 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wk20sg_jenkins"
  }
}

#Create S3 bucket for Jenkins artifacts
resource "aws_s3_bucket" "wk20jenkins-artifacts" {
  bucket = "wk20jenkins-artifacts-${random_id.randomness.hex}"

  tags = {
    Name = "wk20jenkins_artifacts"
  }
}

#Create random number for S3 bucket name
resource "random_id" "randomness" {
  byte_length = 8
}
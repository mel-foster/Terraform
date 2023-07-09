#main.tf for wk21

#Create S3 bucket  
resource "aws_s3_bucket" "s3bucket-week21-melfoster" {
  bucket = "s3bucket-week21-melfoster"

  tags = {
    Name        = "Wk21 S3 Bucket"
    Environment = "development"
  }
}

#Enable versioning
resource "aws_s3_bucket_versioning" "s3bucket-week21-melfoster" {
  bucket = aws_s3_bucket.s3bucket-week21-melfoster.id

  versioning_configuration {
    status = "Enabled"
  }
}
#Block public access to the S3 bucket created above
resource "aws_s3_bucket_public_access_block" "s3bucket-week21-melfoster-accessblock" {
  bucket = aws_s3_bucket.s3bucket-week21-melfoster.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create Launch Template Resource Block
resource "aws_launch_template" "asg_ec2_template" {
  name                   = var.environment
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wk21_security_group.id]
  user_data              = filebase64("script.sh")
  tags = {
    Name = var.environment
  }

}

# Create ASG Resource Block
resource "aws_autoscaling_group" "wk21asg" {
  name               = var.environment
  availability_zones = var.availability_zones
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2
  tag {
    key                 = "Name"
    value               = "wk21EC2_Foster"
    propagate_at_launch = true
  }
  launch_template {
    id      = aws_launch_template.asg_ec2_template.id
    version = aws_launch_template.asg_ec2_template.latest_version
  }
}

# Create Security Group Block
resource "aws_security_group" "wk21_security_group" {
  name        = "wk21_security_group"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.environment
  }
}
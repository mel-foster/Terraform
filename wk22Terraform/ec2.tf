#EC2 Configuration

# Create Launch Template Resource Block & Bootstrap Apache
resource "aws_launch_template" "asg_template" {
  name                   = var.name
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = filebase64("script.sh")

  tags = {
    Name = "${var.name}-template"
  }
}

# Create ASG Resource Block
resource "aws_autoscaling_group" "asg" {
  name                = "${var.name}-asg"
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  tag {
    key                 = "Name"
    value               = "wk22EC2_Foster"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = aws_launch_template.asg_template.latest_version
  }
}
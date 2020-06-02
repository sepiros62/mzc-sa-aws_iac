## Load VPC, SUBNET, AMI, ALB Data ##
data "aws_vpc" "selected" {

   tags = {
     Name = "${var.name}-VPC"
   }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["WAS-Subnet-Private"]
  }
}

data "aws_security_group" "alb" {

   tags = {
     Name = "${var.name}-SG-ALB"
   }
}

data "aws_lb_target_group" "alb" {
   name = "${var.name}-WAS-TG"
}

data "aws_ami" "was" {
  most_recent = true

  name_regex = "\\d{4}-\\d{2}-\\d{2}_\\d{4}_AMI-EC2-WEB"
  owners = ["051542137113"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


## Create Auto Security-Group ##
resource "aws_security_group" "was" {
  name        = "${var.name}-SG-WAS"
  description = "Application Load Balancer Security-Group (port 80, 443)"

  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "443"
    to_port   = "443"
    protocol  = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-SG-WAS"
  }
}


## Create Launch Configuration ##
resource "aws_launch_configuration" "was" {
  name          = "${var.name}-Was-Launch-Configuration"
  image_id      = data.aws_ami.was.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.was.id]

  lifecycle {
    create_before_destroy = true
  }
}


## Create Auto Scaling Group ##
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.name}-ASG"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.was.id
  vpc_zone_identifier  = data.aws_subnet_ids.private.ids

  force_delete              = true
  health_check_grace_period = 300
  health_check_type         = "ELB"
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  alb_target_group_arn   = data.aws_lb_target_group.alb.arn
}

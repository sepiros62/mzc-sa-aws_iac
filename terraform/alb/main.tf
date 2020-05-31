data "aws_vpcs" "selected" {
  tags = {
    Name = "ABC-VPC"
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpcs.selected.id

  filter {
    name   = "tag:Name"
    values = ["ABC-Subnet-Public-*"]
  }
}

resource "aws_security_group" "alb" {
  name        = var.name
  description = "security group for ${var.name}"

  vpc_id = data.aws_vpcs.selected.id

  ingress {
    description = "HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s", var.name)
  }
}

resource "aws_lb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.alb.id
  subnets            = data.aws_subnet_ids.selected.vpc_id

  enable_deletion_protection = true

  tags = {
    Name = format("%s", var.name)
  }
}

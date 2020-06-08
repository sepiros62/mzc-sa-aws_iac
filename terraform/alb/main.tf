## Load VPC, Subnet Data ##
data "aws_vpc" "selected" {

   tags = {
     Name = "${var.name}-VPC"
   }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["ALB-Subnet-Public"]
  }
}

data "aws_acm_certificate" "domain" {
  domain      = var.domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


## Create Aurora Security-Group ##
resource "aws_security_group" "alb" {
  name        = "${var.name}-SG-ALB"
  description = "Application Load Balancer Security-Group (port 80, 443)"

  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name ="${var.name}-SG-ALB"
  }
}

## Create Application Load Balancer ##
resource "aws_lb" "alb" {
  name               = "${var.name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnet_ids.public.ids

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name = "${var.name}-ALB"
  }

  lifecycle {
    create_before_destroy = true
  }

}


## Create ALB Target-Group ##
resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.name}-WAS-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  tags = {
    Name = "${var.name}-WAS-TG"
  }
}


## Create HTTP, HTTPS ALB Listener ##
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = data.aws_acm_certificate.domain.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}


## Create Redirect action ##
resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.http_listener.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["api.${var.domain}"]
    }
  }
}

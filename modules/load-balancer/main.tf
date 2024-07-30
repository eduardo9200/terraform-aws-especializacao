provider "aws" {
  region = var.region
}

resource "aws_lb" "alb_instance" {
  name = var.alb_name
  internal = false
  load_balancer_type = "application"
  security_groups = var.alb_security_group_ids
  subnets = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "My-alb"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = var.target_group_name
  target_type = var.target_type
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    protocol            = "HTTP"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = {
    Name = "My-alb-target-group"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_instance.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

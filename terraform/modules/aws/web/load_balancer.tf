data "aws_elb_service_account" "web_alb" {}

resource "aws_alb" "web" {
  name            = "${var.name}-${var.env}-web-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = var.public_subnets[*].id
  internal        = false
  idle_timeout    = 60

  access_logs {
    bucket  = var.web_alb_log_bucket
    enabled = true
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-alb", var.name, var.env),
    Role = "lb"
  })
}

resource "aws_alb_target_group" "web" {
  name                 = "${var.name}-${var.env}-web-tg"
  vpc_id               = var.vpc.id
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/healthcheck.html"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-tg", var.name, var.env),
    Role = "lb"
  })
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.web.arn
  port              = "80"

  default_action {
    target_group_arn = aws_alb_target_group.web.arn
    type             = "forward"
  }
}


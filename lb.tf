resource "aws_lb" "app_lb" {
  count = var.enable_loadbalancer ? 1 : 0

  name               = substr("lb-${var.cluster_name}-${var.app_name}", 0, min(length("lb-${var.cluster_name}-${var.app_name}"), 32))
  load_balancer_type = "application"
  security_groups    = [var.cluster_lb_sg_id]
  subnets            = flatten([var.lb_public_subnets])
  internal           = var.is_lb_internal

  access_logs {
    bucket  = var.alb_access_logs_bucket
    prefix  = "${var.app_name}-logs"
    enabled = var.alb_access_logs_enabled
  }

  tags = {
    Name = "Application LB ${var.app_name}"
  }
}

resource "aws_lb_listener" "secure_listener" {
  count = var.enable_loadbalancer ? 1 : 0

  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.lb_security_policy
  certificate_arn   = var.lb_cert_arn

  default_action {
    target_group_arn = aws_lb_target_group.lb_targets.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "redirect_listener" {
  count = var.secure_listener_enabled && var.enable_loadbalancer ? 1 : 0

  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# typically not used unless you have a client that can't follow redirects for some reason
resource "aws_lb_listener" "insecure_listener" {
  count = var.secure_listener_enabled && var.enable_loadbalancer ? 0 : 1

  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_targets.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "lb_targets" {
  count = var.enable_loadbalancer ? 1 : 0

  name                 = substr("tg-${var.cluster_name}-${var.app_name}", 0, min(length("lb-${var.cluster_name}-${var.app_name}"), 32))
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"
  deregistration_delay = "60"

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  lifecycle {
    create_before_destroy = true
  }
}

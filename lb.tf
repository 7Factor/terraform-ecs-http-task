resource "aws_lb" "app_lb" {
  name               = "${substr("var.cluster_name-var.app_name", 0, 32)}"
  load_balancer_type = "application"
  subnets            = ["${var.lb_public_subnets}"]
  security_groups    = ["${var.cluster_lb_sg_id}"]

  tags {
    Name = "Application LB ${var.app_name}"
  }
}

resource "aws_lb_listener" "secure_listener" {
  load_balancer_arn = "${aws_lb.app_lb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.lb_security_policy}"
  certificate_arn   = "${var.lb_cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.lb_targets.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "redirect_listener" {
  load_balancer_arn = "${aws_lb.app_lb.arn}"
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

resource "aws_lb_target_group" "lb_targets" {
  name                 = "${var.app_name}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "instance"
  deregistration_delay = "60"

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_check_port}"
    protocol            = "${var.health_check_protocol}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    matcher             = "${var.health_check_matcher}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

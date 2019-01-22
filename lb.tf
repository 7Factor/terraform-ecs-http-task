resource "aws_lb" "app_lb" {
  name               = "${var.app_name}-lb"
  load_balancer_type = "application"
  subnets            = ["${var.lb_public_subnets}"]
  security_groups    = ["${aws_security_group.httplb_sg.id}"]

  tags {
    Name = "${var.app_name} LB"
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "main_load_balancer" {
  name               = "${var.app_name}-lb-${var.env}"
  load_balancer_type = "application"
  subnets            = ["${var.alb_subnets}"]
  security_groups    = ["${var.lb_security_group_id}"]

  tags {
    Name    = "${var.app_name} LB"
    Service = "${var.service_name}"
    Env     = "${var.env}"
  }
}

resource "aws_lb_listener" "main_alb_listener" {
  load_balancer_arn = "${aws_lb.main_load_balancer.arn}"
  port              = "${var.alb_port}"
  protocol          = "HTTP"

  "default_action" {
    target_group_arn = "${aws_lb_target_group.main_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "main_target_group" {
  name                 = "${var.app_name}-tg-${var.env}"
  port                 = "${var.alb_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "instance"
  deregistration_delay = "60"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Service = "${var.service_name}"
  }
}

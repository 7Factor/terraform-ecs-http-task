# We assume only 443 and 80 on an application load balancer.
# Instead of allowing users to pass one in we just make it for
# them here since this is an HTTP task module. More interesting
# configurations should be custom built.
resource "aws_security_group" "httplb_sg" {
  name   = "${var.app_name}-lb-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.lb_ingress_cidr}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.lb_ingress_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.app_name} load balancer"
  }
}

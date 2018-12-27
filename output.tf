output "lb_hostname" {
  value = "${aws_lb.main_load_balancer.dns_name}"
}

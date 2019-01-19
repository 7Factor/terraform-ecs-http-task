output "lb_hostname" {
  value = "${aws_lb.app_lb.dns_name}"
}

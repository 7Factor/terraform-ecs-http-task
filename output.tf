output "lb_hostname" {
  value = "${aws_lb.app_lb.dns_name}"
}

output "lb_zone_id" {
  value = "${aws_lb.app_lb.zone_id}"
}

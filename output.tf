output "lb_hostname" {
  value = "${aws_lb.app_lb.dns_name}"
}

output "health_check_path" {
  value = "${var.health_check_path}"
}

output "lb_zone_id" {
  value = "${aws_lb.app_lb.zone_id}"
}

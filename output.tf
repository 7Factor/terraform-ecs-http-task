output "lb_hostname" {
  value = "${aws_lb.app_lb.dns_name}"
}

output "health_check_path" {
  value = "${aws_lb_target_group.lb_targets.health_check.path}"
}

output "lb_zone_id" {
  value = "${aws_lb.app_lb.zone_id}"
}

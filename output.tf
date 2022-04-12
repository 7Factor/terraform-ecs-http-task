output "lb_hostname" {
  value = aws_lb.app_lb.dns_name
}

output "lb_name" {
  value = aws_lb.app_lb.name
}

output "lb_arn" {
  value = aws_lb.app_lb.arn
}

output "lb_arn_suffix" {
  value = aws_lb.app_lb.arn_suffix
}

output "lb_secure_listener" {
  value = aws_lb_listener.secure_listener.arn
}

output "lb_target_group_name" {
  value = aws_lb_target_group.lb_targets.name
}

output "lb_target_group_arn_suffix" {
  value = aws_lb_target_group.lb_targets.arn_suffix
}

output "health_check_path" {
  value = var.health_check_path
}

output "lb_zone_id" {
  value = aws_lb.app_lb.zone_id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.main_task.arn
}

output "service_name" {
  value = aws_ecs_service.main_service.name
}
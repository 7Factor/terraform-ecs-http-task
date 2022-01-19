data "aws_ecs_cluster" "target_cluster" {
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "main_task" {
  family                = "${var.app_name}-tsk"
  network_mode          = "bridge"
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = var.container_definition

  task_role_arn = var.task_role_arn

  dynamic "volume" {
    for_each = [for v in var.volumes : {
      name      = v.name
      host_path = v.host_path
    }]

    content {
      name      = volume.value.name
      host_path = volume.value.host_path
    }
  }
}

resource "aws_ecs_service" "main_service" {
  name                               = "${var.app_name}-svc"
  task_definition                    = aws_ecs_task_definition.main_task.arn
  cluster                            = data.aws_ecs_cluster.target_cluster.id
  desired_count                      = var.desired_task_count
  iam_role                           = var.service_role_arn
  launch_type                        = var.launch_type
  deployment_maximum_percent         = var.service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.service_deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.health_check_grace_period

  deployment_circuit_breaker {
    enable   = var.circuit_breaker_enabled
    rollback = var.circuit_breaker_rollback_enabled
  }

  load_balancer {
    container_name   = var.app_name
    container_port   = var.app_port
    target_group_arn = aws_lb_target_group.lb_targets.arn
  }

  depends_on = [aws_lb.app_lb]

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategies
    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
      # this is critical to include, to prevent the service from being rebuilt on every deploy
      # thus causing the service to become unavailable during a deploy
      capacity_provider_strategy
    ]
  }
}

data "aws_ecs_service" "main_service" {
  cluster_arn  = data.aws_ecs_cluster.target_cluster.arn
  service_name = aws_ecs_service.main_service.name
}

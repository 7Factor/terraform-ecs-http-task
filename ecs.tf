data "aws_ecs_cluster" "target_cluster" {
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "main_task" {
  family                   = "${var.app_name}-tsk"
  requires_compatibilities = [var.launch_type]
  network_mode             = "bridge"
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.container_definition

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
  name                       = "${var.app_name}-svc"
  task_definition            = aws_ecs_task_definition.main_task.arn
  cluster                    = data.aws_ecs_cluster.target_cluster.id
  desired_count              = var.desired_task_count
  iam_role                   = var.service_role_arn
  launch_type                = var.launch_type
  deployment_maximum_percent = var.service_deployment_maximum_percent

  dynamic "load_balancer" {
    for_each = aws_lb.app_lb == null ? [] : list(1)

    content {
      container_name   = var.app_name
      container_port   = var.app_port
      target_group_arn = aws_lb_target_group.lb_targets.arn
    }
  }
}

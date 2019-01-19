resource "aws_ecs_task_definition" "main_task" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  container_definitions    = "${var.container_definition}"
}

resource "aws_ecs_service" "main_service" {
  name            = "${var.app_name}-service"
  task_definition = "${aws_ecs_task_definition.main_task.arn}"
  cluster         = "${var.cluster_id}"
  desired_count   = "${var.desired_task_count}"
  iam_role        = "${var.service_role_arn}"
  launch_type     = "${var.launch_type}"

  load_balancer {
    container_name   = "${var.app_name}-container"
    container_port   = "${var.app_port}"
    target_group_arn = "${aws_lb_target_group.lb_targets.arn}"
  }

  depends_on = ["aws_lb.app_lb"]
}

data "aws_ecs_cluster" "base_cluster" {
  cluster_name = "base-cluster"
}

resource "aws_ecs_task_definition" "main_task" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"

  container_definitions = "${var.container_definitions}"
}

resource "aws_ecs_service" "main_service" {
  name            = "${var.app_name}-service"
  task_definition = "${aws_ecs_task_definition.main_task.arn}"
  cluster         = "${data.aws_ecs_cluster.base_cluster.id}"
  desired_count   = "${var.desired_task_count}"
  iam_role        = "${var.service_role_arn}"
  launch_type     = "EC2"

  load_balancer {
    container_name   = "${var.app_name}-container"
    container_port   = "${var.app_port}"
    target_group_arn = "${aws_lb_target_group.main_target_group.arn}"
  }

  depends_on = ["aws_lb.main_load_balancer"]
}

resource "aws_sns_topic" "ecs_task_deployment_failure_sns_topic" {
  count = var.circuit_breaker_failure_events_enabled && var.circuit_breaker_sns_topic_arn == null ? 1 : 0

  name = "${aws_ecs_service.main_service.name}-deployment-failure"
}

resource "aws_sns_topic_policy" "ecs_task_deployment_failure_sns_topic_policy" {
  count = var.circuit_breaker_failure_events_enabled ? 1 : 0

  arn    = coalesce(var.circuit_breaker_sns_topic_arn, aws_sns_topic.ecs_task_deployment_failure_sns_topic[0].arn)
  policy = data.aws_iam_policy_document.ecs_task_deployment_failure_sns_topic_policy[0].json
}

resource "aws_cloudwatch_event_rule" "ecs_task_deployment_failure" {
  count = var.circuit_breaker_failure_events_enabled ? 1 : 0

  name        = "${aws_ecs_service.main_service.name}-deployment-failure"
  description = "Task deployment failed"

  event_pattern = jsonencode({
    detail-type = ["ECS Deployment State Change"]
    source      = ["aws.ecs"]
    resources   = [data.aws_ecs_service.main_service.arn]
    detail      = {
      eventType = ["ERROR"]
      eventName = ["SERVICE_DEPLOYMENT_FAILED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_task_deployment_failure_sns" {
  count = var.circuit_breaker_failure_events_enabled ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ecs_task_deployment_failure[0].name
  target_id = "SendToSNS"
  arn       = coalesce(var.circuit_breaker_sns_topic_arn, aws_sns_topic.ecs_task_deployment_failure_sns_topic[0].arn)
}

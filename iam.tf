data "aws_iam_policy_document" "ecs_task_deployment_failure_sns_topic_policy" {
  count = var.circuit_breaker_failure_events_enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      coalesce(var.circuit_breaker_sns_topic_arn, aws_sns_topic.ecs_task_deployment_failure_sns_topic[0].arn)
    ]
  }
}

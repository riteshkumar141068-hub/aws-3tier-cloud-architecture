output "sns_topic_arn" {
  description = "SNS topic ARN for alarms"
  value       = aws_sns_topic.alerts.arn
}

output "application_log_group_name" {
  description = "CloudWatch application log group name"
  value       = aws_cloudwatch_log_group.application.name
}

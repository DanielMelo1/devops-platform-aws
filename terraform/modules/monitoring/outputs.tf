output "sns_topic_arn" {
  description = "ARN do topico SNS — usado para adicionar mais alarmes"
  value       = aws_sns_topic.alarms.arn
}

output "rds_cpu_alarm_arn" {
  description = "ARN do alarme de CPU do RDS"
  value       = aws_cloudwatch_metric_alarm.rds_cpu.arn
}

output "eks_node_cpu_alarm_arn" {
  description = "ARN do alarme de CPU dos nodes EKS"
  value       = aws_cloudwatch_metric_alarm.eks_node_cpu.arn
}

output "alb_dns_name" {
  description = "Public URL (DNS Name) of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS Database endpoint"
  value       = module.rds.rds_instance_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alerts_topic_arn" {
  description = "SNS Topic ARN for CloudWatch Alarms"
  value       = module.monitoring.sns_topic_arn
}

output "app_tg_arn" {
  description = "Application Target Group ARN"
  value       = aws_lb_target_group.app_tg.arn
}

output "app_lb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.app_lb.arn
}

output "app_lb_dns_name" {
  description = "Application ALB DNS name"
  value       = aws_lb.app_lb.dns_name
}
